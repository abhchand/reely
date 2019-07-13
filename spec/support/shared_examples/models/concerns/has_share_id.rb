require "spec_helper"

RSpec.shared_examples "has share id" do
  subject { create(described_class.table_name.singularize) }

  describe "Validations" do
    it { should validate_presence_of(:share_id) }
    it { should validate_uniqueness_of(:share_id) }
  end

  describe "callbacks" do
    describe "before_validation" do
      describe "#generate_share_id" do
        it "generates a share id on creation" do
          model = create(
            described_class.table_name.singularize,
            share_id: nil
          )

          expect(model.share_id).to_not be_nil
        end
      end
    end
  end
end
