require "rails_helper"

RSpec.describe JsonApiSerializer do
  let!(:models) do
    # Test with the `Skill` model because it's a simple enough model and has
    # both 1:1 and 1-to-many relationships to test with
    create_list(:skill, 2)
  end

  describe "serializing the dataset" do
    context "data is a model class" do
      it "serializes all records ordered by :id, by default" do
        result = serialize(Skill)

        expect_results_to_be(result, [models[0], models[1]])
      end
    end

    context "data is a single record" do
      it "serializes the model" do
        result = serialize(models[1])

        expect_results_to_be(result, models[1])
      end
    end

    context "data is an array of records" do
      it "serializes the models" do
        result = serialize([models[1], models[0]])

        expect_results_to_be(result, [models[1], models[0]])
      end

      context "data is empty" do
        it "raises an error" do
          result = nil

          expect do
            result = serialize([])
          end.to raise_error(/Unknown model class/)
        end
      end
    end

    context "data is an ActiveRecord collection of records" do
      it "serializes the models" do
        result = serialize(Skill.order(id: :desc))

        expect_results_to_be(result, [models[1], models[0]])
      end

      context "data is empty" do
        it "does not raise an error and still serializes the models" do
          result = nil

          expect do
            result = serialize(Skill.where(name: "xyz"))
          end.to_not raise_error

          expect_results_to_be(result, [])
        end
      end
    end
  end

  context "`includes` option is specified on serializer_opts" do
    context "`:denormalize` is set to false" do
      it "does nothing" do
        result = serialize(
          models[1],
          denormalize: false,
          serializer_opts: { include: %i[discipline] }
        )

        relationships = result[:data][:relationships]
        expect(relationships[:discipline][:data].keys).to_not include(:attributes)
        expect(relationships[:discipline][:data].keys).to include(:id)
        expect(relationships[:discipline][:data].keys).to include(:type)
      end
    end

    context "`:denormalize` is set to true" do
      context "serializing a single record" do
        it "denormalizes singular associations (has_one or belongs_to)" do
          result = serialize(
            models[1],
            denormalize: true,
            serializer_opts: { include: %i[discipline] }
          )

          relationships = result[:data][:relationships]
          expect(relationships[:discipline][:data].keys).to include(:attributes)
        end

        it "denormalizes plural associations (has_many)" do
          create(:level, skill: models[1])

          result = serialize(
            models[1],
            denormalize: true,
            serializer_opts: { include: %i[levels] }
          )

          relationships = result[:data][:relationships]
          relationships[:levels][:data].each do |level_data|
            expect(level_data.keys).to include(:attributes)
          end
        end

        context "no included data is found" do
          it "does not alter the existing association" do
            create(:level, skill: models[1])

            result = serialize(
              models[1],
              denormalize: true,
              serializer_opts: { include: %i[] }
            )

            relationships = result[:data][:relationships]
            relationships[:levels][:data].each do |level_data|
              expect(level_data.keys).to_not include(:attributes)
              expect(level_data.keys).to include(:id)
              expect(level_data.keys).to include(:type)
            end
          end
        end
      end

      context "serializing a collection of records" do
        it "denormalizes singular associations (has_one or belongs_to)" do
          result = serialize(
            [models[0], models[1]],
            denormalize: true,
            serializer_opts: { include: %i[discipline] }
          )

          result[:data].each do |record|
            relationships = record[:relationships]
            expect(relationships[:discipline][:data].keys).to include(:attributes)
          end
        end

        it "denormalizes plural associations (has_many)" do
          create(:level, skill: models[1])

          result = serialize(
            [models[0], models[1]],
            denormalize: true,
            serializer_opts: { include: %i[levels] }
          )

          result[:data].each do |record|
            relationships = record[:relationships]
            relationships[:levels][:data].each do |level_data|
              expect(level_data.keys).to include(:attributes)
            end
          end
        end

        context "no included data is found" do
          it "does not alter the existing association" do
            create(:level, skill: models[1])

            result = serialize(
              [models[0], models[1]],
              denormalize: true,
              serializer_opts: { include: %i[] }
            )

            result[:data].each do |record|
              relationships = record[:relationships]
              relationships[:levels][:data].each do |level_data|
                expect(level_data.keys).to_not include(:attributes)
                expect(level_data.keys).to include(:id)
                expect(level_data.keys).to include(:type)
              end
            end
          end
        end
      end
    end
  end

  def serialize(data, opts = {})
    JsonApiSerializer.serialize(data, opts)
  end

  def expect_results_to_be(result, records)
    if records.is_a?(Array)
      expect(result[:data].map { |r| r[:id] }).
        to eq(records.map(&:id).map(&:to_s))
    else
      expect(result[:data][:id]).to eq(records.id.to_s)
    end
  end
end
