require "rails_helper"

RSpec.describe ProductFeedback do
  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe "Validations" do
    it { should validate_presence_of(:user) }

    describe "#body" do
      it { should validate_presence_of(:body) }

      it do
        should validate_length_of(:body).
          is_at_most(ProductFeedback::MAX_BODY_LENGTH)
      end
    end
  end
end
