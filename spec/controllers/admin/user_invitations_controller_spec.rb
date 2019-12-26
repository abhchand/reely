require "rails_helper"

RSpec.describe Admin::UserInvitationsController, type: :controller do
  let(:admin) do
    create(:user, :admin, first_name: "Alonso", last_name: "Harris")
  end

  before { sign_in(admin) }

  describe "GET index" do
    it "calls the `admin_only` filter" do
      expect(controller).to receive(:admin_only).and_call_original
      get :index
    end

    context "format html" do
      let(:params) { {} }

      before { params[:format] = "html" }

      it "should render the template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context "format json" do
      render_views

      let(:params) do
        {
          page: 1,
          search: nil
        }
      end

      let(:user_invitation_attributes) do
        [
          { email: "deca.gram@x.yz" },
          { email: "kilo.gram@x.yz" },
          { email: "milli.gram@x.yz" }
        ]
      end

      let!(:user_invitations) do
        [].tap do |u|
          user_invitation_attributes.each do |attrs|
            u << create(:user_invitation, attrs)
          end
        end
      end

      before { params[:format] = "json" }

      it "should return the search results and metadata" do
        get :index, params: params

        ids = json_response["items"].map { |u| u["id"] }
        expect(ids).to eq(
          [
            user_invitations[0],
            user_invitations[1],
            user_invitations[2]
          ].map(&:id)
        )

        expect(json_response["current_page"]).to eq(1)
        expect(json_response["total_pages"]).to eq(1)
        expect(json_response["total_items"]).to eq(3)
      end

      context "a search value is specified" do
        before { params[:search] = "l" }

        it "should return the search results and metadata" do
          get :index, params: params

          ids = json_response["items"].map { |u| u["id"] }
          expect(ids).to eq(
            [
              user_invitations[1],
              user_invitations[2]
            ].map(&:id)
          )

          expect(json_response["current_page"]).to eq(1)
          expect(json_response["total_pages"]).to eq(1)
          expect(json_response["total_items"]).to eq(2)
        end
      end

      context "pagination is specified" do
        before do
          params[:page] = 2
          params[:page_size] = 2
        end

        it "should return the search results and metadata" do
          get :index, params: params

          ids = json_response["items"].map { |u| u["id"] }
          expect(ids).to eq([user_invitations[2]].map(&:id))

          expect(json_response["current_page"]).to eq(2)
          expect(json_response["total_pages"]).to eq(2)
          expect(json_response["total_items"]).to eq(3)
        end
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
