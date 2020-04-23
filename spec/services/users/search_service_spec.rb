require "rails_helper"

RSpec.describe Users::SearchService, type: :interactor do
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
    [].tap { |u| user_attributes.each { |attrs| u << create(:user, attrs) } }
  end

  describe "#perform" do
    it "searches by first name" do
      results = perform(User.all, "Leonardo").to_a
      expect(results).to eq([users[0]])
    end

    it "searches by last name" do
      results = perform(User.all, "Davinci").to_a
      expect(results).to eq([users[0]])
    end

    it "searches by email" do
      results = perform(User.all, "leo@def.it").to_a
      expect(results).to eq([users[0]])
    end

    it "searches by partial token match" do
      results = perform(User.all, "Leo").to_a
      expect(results).to eq([users[0]])
    end

    it "searches case insensitively" do
      results = perform(User.all, "LeOnArDo").to_a
      expect(results).to eq([users[0]])
    end

    context "multiple search tokens" do
      it "searches by AND across all fields" do
        users[0].update!(first_name: "xxx", last_name: "yyy")
        users[1].update!(first_name: "xxx", last_name: "yyy")
        users[2].update!(first_name: "xxx")

        results = perform(User.all, "yyy xxx").to_a
        expect(results).to eq([users[0], users[1]])
      end

      it "handles multiple spaces between tokens" do
        results = perform(User.all, "o   el").to_a
        expect(results).to eq([users[1], users[2]])
      end
    end

    context "search is blank" do
      it "does not filter the results in any way" do
        results = perform(User.all, "").to_a
        expect(results).to eq(users)
      end
    end
  end

  def perform(users, search)
    service(users, search).perform
  end

  def service(users, search)
    Users::SearchService.new(users, search)
  end
end
