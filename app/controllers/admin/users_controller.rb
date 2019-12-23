class Admin::UsersController < AdminController
  def index
    respond_to do |format|
      format.json do
        @users = UserPresenter.wrap(search_service.perform, view: view_context)
      end

      format.html {}
    end
  end

  private

  def search_params
    params.permit(
      :search,
      :page,
      :page_size
    )
  end

  def search_service
    @search_service ||= Users::SearchService.new(search_params)
  end
end
