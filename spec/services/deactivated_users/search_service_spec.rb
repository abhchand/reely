require "rails_helper"

RSpec.describe DeactivatedUsers::SearchService, type: :interactor do
  let(:params) do
    {
      page: 1,
      search: nil
    }
  end

  let(:user_attributes) do
    # rubocop:disable Metrics/LineLength
    [
      { first_name: "Leonardo", last_name: "Davinci", email: "leo@def.it" },
      { first_name: "Michelangelo", last_name: "Simoni", email: "mikey@abc.it" },
      { first_name: "Donatello", last_name: "Bardi", email: "donny@ghi.it" }
    ]
    # rubocop:enable Metrics/LineLength
  end

  let!(:users) do
    [].tap do |u|
      user_attributes.each { |attrs| u << create(:user, :deactivated, attrs) }
    end
  end

  describe "#perform" do
    it "returns a list of all users ordered by first name" do
      results = perform
      expect(results).to eq([users[2], users[0], users[1]])
    end

    it "excludes any activated users" do
      users[0].update!(deactivated_at: nil)

      results = perform
      expect(results).to eq([users[2], users[1]])
    end

    it "falls back on last name and email for sorting" do
      # rubocop:disable Metrics/LineLength
      users[0].update_columns(first_name: "Leonardo", last_name: "EEEEEEE", email: "zzz@2.gov")
      users[1].update_columns(first_name: "Leonardo", last_name: "EEEEEEE", email: "leo@2.gov")
      users[2].update_columns(first_name: "Leonardo", last_name: "Davinci", email: "leo@1.gov")
      # rubocop:enable Metrics/LineLength

      results = perform
      expect(results).to eq([users[2], users[1], users[0]])
    end

    it "orders case insensitively" do
      user_attributes[0][:email] = "LEONARDO.davinci@artist.gov"

      results = perform
      expect(results).to eq(
        [
          users[2],
          users[0],
          users[1]
        ]
      )
    end

    describe "searching" do
      it "searches by first name" do
        results = perform(search: "Leonardo")
        expect(results).to eq([users[0]])
      end

      it "searches by last name" do
        results = perform(search: "Davinci")
        expect(results).to eq([users[0]])
      end

      it "searches by email" do
        results = perform(search: "leo@def.it")
        expect(results).to eq([users[0]])
      end

      it "searches by partial token match" do
        results = perform(search: "Leo")
        expect(results).to eq([users[0]])
      end

      it "searches case insensitively" do
        results = perform(search: "LeOnArDo")
        expect(results).to eq([users[0]])
      end

      context "multiple search tokens" do
        it "searches by AND across all fields" do
          # Use `update_column` to avoid model validation on email format
          users[0].update_column(:email, "xxxyyy")
          users[1].update_column(:email, "xxyy")
          users[2].update_column(:email, "xxx")

          results = perform(search: "yy xx")
          expect(results).to eq([users[0], users[1]])
        end

        it "handles multiple spaces between tokens" do
          # Use `update_column` to avoid model validation on email format
          users[0].update_column(:email, "xxxyyy")
          users[1].update_column(:email, "xxyy")
          users[2].update_column(:email, "xxx")

          results = perform(search: "yy   xx")
          expect(results).to eq([users[0], users[1]])
        end
      end
    end

    describe "pagination" do
      before { params[:page_size] = 2 }

      it "paginates the result set" do
        results = perform
        expect(results).to eq([users[2], users[0]])

        results = perform(page: 2)
        expect(results).to eq([users[1]])

        results = perform(page: 3)
        expect(results).to eq([])
      end

      describe "searching paginated results" do
        it "paginates the result set" do
          # Add a 4th so we have enough users to test a scenario where we
          # filter some out and are still left with at least one page
          # Luckily, there's a 4th ninja turtle!
          users << create(
            :user,
            :deactivated,
            first_name: "Raphael",
            last_name: "Urbino",
            email: "raphael@jkl.it"
          )

          # Everyone except "Leonardo" have an "el"

          results = perform(search: "el")
          expect(results).to eq([users[2], users[1]])

          results = perform(search: "el", page: 2)
          expect(results).to eq([users[3]])
        end
      end
    end
  end

  describe "#total_users" do
    it "returns the full user count, even when paginated" do
      params[:page_size] = 4

      search_service = service
      search_service.perform
      expect(search_service.total_users).to eq(3)

      params[:page_size] = 2

      search_service = service
      search_service.perform

      expect(search_service.total_users).to eq(3)
    end
  end

  describe "#total_pages" do
    it "returns the full user count, even when paginated" do
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
    DeactivatedUsers::SearchService.new(params.merge(opts))
  end
end
