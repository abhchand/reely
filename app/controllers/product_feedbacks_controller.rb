class ProductFeedbacksController < ApplicationController
  before_action :ensure_json_request, only: %i[create]

  def create
    @feedback = ProductFeedback.new(create_params.merge(user: current_user))
    status = @feedback.save ? 200 : 400

    json = {}
    json[:error] = @feedback.errors.messages[:body].first if status == 400

    respond_to { |format| format.json { render json: json, status: status } }
  end

  private

  def create_params
    params.require(:product_feedback).permit(:body)
  end
end
