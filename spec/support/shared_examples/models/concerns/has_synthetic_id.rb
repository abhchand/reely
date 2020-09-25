require 'spec_helper'

RSpec.shared_examples 'has synthetic id' do
  subject { create(described_class.table_name.singularize) }

  describe 'Validations' do
    it { should validate_presence_of(:synthetic_id) }
    it { should validate_uniqueness_of(:synthetic_id) }
  end

  describe 'callbacks' do
    describe 'before_validation' do
      describe '#generate_synthetic_id' do
        it 'generates a synthetic id on creation' do
          model =
            create(described_class.table_name.singularize, synthetic_id: nil)

          expect(model.synthetic_id).to_not be_nil
        end
      end
    end
  end
end
