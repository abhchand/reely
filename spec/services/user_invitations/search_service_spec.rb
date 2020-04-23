require "rails_helper"

RSpec.describe UserInvitations::SearchService, type: :interactor do
  let(:user_invitation_attributes) do
    [
      { email: "leonardo.davinci@artist.gov" },
      { email: "michelangelo.simoni@artist.gov" },
      { email: "donatello.bardi@artist.gov" }
    ]
  end

  let!(:user_invitations) do
    [].tap do |u|
      user_invitation_attributes.each do |attrs|
        u << create(:user_invitation, attrs)
      end
    end
  end

  describe "#perform" do
    it "searches by email" do
      results = perform(UserInvitation.all, "leonardo.davinci@artist.gov")
      expect(results).to eq([user_invitations[0]])
    end

    it "searches by partial token match" do
      results = perform(UserInvitation.all, "Leo")
      expect(results).to eq([user_invitations[0]])
    end

    it "searches case insensitively" do
      results = perform(UserInvitation.all, "LeOnArDo")
      expect(results).to eq([user_invitations[0]])
    end

    context "multiple search tokens" do
      it "searches by AND across all fields" do
        user_invitations[0].update!(email: "xxxyyy")
        user_invitations[1].update!(email: "xxyy")
        user_invitations[2].update!(email: "xxx")

        results = perform(UserInvitation.all, "yy xx")
        expect(results).to eq([user_invitations[0], user_invitations[1]])
      end

      it "handles multiple spaces between tokens" do
        user_invitations[0].update!(email: "xxxyyy")
        user_invitations[1].update!(email: "xxyy")
        user_invitations[2].update!(email: "xxx")

        results = perform(UserInvitation.all, "yy   xx")
        expect(results).to eq([user_invitations[0], user_invitations[1]])
      end
    end

    context "search is blank" do
      it "does not filter the results in any way" do
        results = perform(UserInvitation.all, "").to_a
        expect(results).to eq(user_invitations)
      end
    end
  end

  def perform(user_invitations, search)
    service(user_invitations, search).perform
  end

  def service(user_invitations, search)
    UserInvitations::SearchService.new(user_invitations, search)
  end
end
