require "rails_helper"

RSpec.describe JsonApiSerializer do
  let!(:models) do
    # Pick arbitrary model to test with (e.g. `Skill`)
    create_list(:skill, 2)
  end

  describe ".serialize" do
    context "input data is a model class" do
      it "serializes all records ordered by :id, by default" do
        result = serialize(Skill)

        expect_results_to_be(result, [models[0], models[1]])
      end
    end

    context "input data is a single record" do
      it "serializes the model" do
        result = serialize(models[1])

        expect_results_to_be(result, models[1])
      end
    end

    context "input data is an array of records" do
      it "serializes the models" do
        result = serialize([models[1], models[0]])

        expect_results_to_be(result, [models[1], models[0]])
      end

      context "input data is empty" do
        it "raises an error" do
          result = nil

          expect do
            result = serialize([])
          end.to raise_error(/Unknown model class/)
        end
      end
    end

    context "input data is an ActiveRecord collection of records" do
      it "serializes the models" do
        result = serialize(Skill.order(id: :desc))

        expect_results_to_be(result, [models[1], models[0]])
      end

      context "input data is empty" do
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
