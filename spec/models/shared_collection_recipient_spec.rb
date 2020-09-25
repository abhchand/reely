require 'rails_helper'

RSpec.describe SharedCollectionRecipient, type: :model do
  describe 'Associations' do
    it { should belong_to(:collection) }
    it { should belong_to(:recipient) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:collection_id) }

    describe 'recipient_id' do
      subject { build(:shared_collection_recipient) }

      it { should validate_presence_of(:recipient_id) }
      it do
        should validate_uniqueness_of(:recipient_id).scoped_to(:collection_id)
      end
    end
  end
end
