require "rails_helper"

RSpec.describe ProductFeedbacksController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "POST #create" do
    let(:params) do
      {
        product_feedback: {
          body: "Hey, nice work"
        }
      }
    end

    context "format html" do
      before { params[:format] = "html" }

      it "redirects to root_path" do
        post :create, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context "format json" do
      before { params[:format] = "json" }

      it "creates the feedback and responds as success" do
        expect do
          post :create, params: params
        end.to change { ProductFeedback.count }.by(1)

        product_feedback = ProductFeedback.last

        expect(product_feedback.user).to eq(user)
        expect(product_feedback.body).to eq("Hey, nice work")

        expect(response.status).to eq(200)
        expect(response.body).to eq("{}")
      end

      context "there is an error while creating product feedback" do
        before { params[:product_feedback][:body] = "" }

        it "does not create the product feedback and responds as failure" do
          expect do
            post :create, params: params
          end.to_not(change { ProductFeedback.count })

          expect(response.status).to eq(400)
          message = validation_error_for(:body, :blank, klass: ProductFeedback)
          expect(JSON.parse(response.body)).to eq("error" => message)
        end
      end
    end
  end
end
