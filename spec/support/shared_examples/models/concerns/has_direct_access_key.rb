require "spec_helper"

RSpec.shared_examples "has direct access key" do
  subject { create(described_class.table_name.singularize) }

  describe "Validations" do
    it { should validate_presence_of(:direct_access_key) }
    it { should validate_uniqueness_of(:direct_access_key) }
  end

  describe "callbacks" do
    describe "before_validation" do
      describe "#generate_direct_access_key" do
        it "generates a synthetic id on creation" do
          model = create(
            described_class.table_name.singularize,
            direct_access_key: nil
          )

          expect(model.direct_access_key).to_not be_nil
        end
      end
    end
  end
end
