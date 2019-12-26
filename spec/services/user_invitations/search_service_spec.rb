require "rails_helper"

RSpec.describe UserInvitations::SearchService, type: :interactor do
  let(:params) do
    {
      page: 1,
      search: nil
    }
  end

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
    it "returns a list of all UserInvitations ordered by email" do
      results = perform
      expect(results).to eq(
        [
          user_invitations[2],
          user_invitations[0],
          user_invitations[1]
        ]
      )
    end

    it "excludes any invitations where the user has already signed up" do
      user_invitations[0].update!(invitee: create(:user))

      results = perform
      expect(results).to eq([user_invitations[2], user_invitations[1]])
    end

    it "orders case insensitively" do
      user_invitation_attributes[0][:email] = "LEONARDO.davinci@artist.gov"

      results = perform
      expect(results).to eq(
        [
          user_invitations[2],
          user_invitations[0],
          user_invitations[1]
        ]
      )
    end

    describe "searching" do
      it "searches by email" do
        results = perform(search: "leonardo.davinci@artist.gov")
        expect(results).to eq([user_invitations[0]])
      end

      it "searches by partial token match" do
        results = perform(search: "Leo")
        expect(results).to eq([user_invitations[0]])
      end

      it "searches case insensitively" do
        results = perform(search: "LeOnArDo")
        expect(results).to eq([user_invitations[0]])
      end

      context "multiple search tokens" do
        it "searches by AND across all fields" do
          user_invitations[0].update!(email: "xxxyyy")
          user_invitations[1].update!(email: "xxyy")
          user_invitations[2].update!(email: "xxx")

          results = perform(search: "yy xx")
          expect(results).to eq([user_invitations[0], user_invitations[1]])
        end

        it "handles multiple spaces between tokens" do
          user_invitations[0].update!(email: "xxxyyy")
          user_invitations[1].update!(email: "xxyy")
          user_invitations[2].update!(email: "xxx")

          results = perform(search: "yy   xx")
          expect(results).to eq([user_invitations[0], user_invitations[1]])
        end
      end
    end

    describe "pagination" do
      before { params[:page_size] = 2 }

      it "paginates the result set" do
        results = perform
        expect(results).to eq([user_invitations[2], user_invitations[0]])

        results = perform(page: 2)
        expect(results).to eq([user_invitations[1]])

        results = perform(page: 3)
        expect(results).to eq([])
      end

      describe "searching paginated results" do
        it "paginates the result set" do
          # Add a 4th so we have enough user_invitations to test a scenario
          # where we filter some out and are still left with at least one page
          # Luckily, there's a 4th ninja turtle!
          user_invitations << create(:user_invitation, email: "raphael@jkl.it")

          # Everyone except "Leonardo" have an "el"

          results = perform(search: "el")
          expect(results).to eq([user_invitations[2], user_invitations[1]])

          results = perform(search: "el", page: 2)
          expect(results).to eq([user_invitations[3]])
        end
      end
    end
  end

  describe "#total_user_invitations" do
    it "returns the full user_invitation count, even when paginated" do
      params[:page_size] = 4

      search_service = service
      search_service.perform
      expect(search_service.total_user_invitations).to eq(3)

      params[:page_size] = 2

      search_service = service
      search_service.perform

      expect(search_service.total_user_invitations).to eq(3)
    end
  end

  describe "#total_pages" do
    it "returns the full user_invitation count, even when paginated" do
      params[:page_size] = 4

      search_service = service
      search_service.perform
      expect(search_service.total_pages).to eq(1)

      params[:page_size] = 2

      search_service = service
      search_service.perform

      expect(search_service.total_pages).to eq(2)
    end
  end

  def perform(opts = {})
    service(opts).perform
  end

  def service(opts = {})
    UserInvitations::SearchService.new(params.merge(opts))
  end
end
