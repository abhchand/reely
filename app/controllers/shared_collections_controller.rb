class SharedCollectionsController < CollectionsController
  layout "application"

  skip_before_action :authenticate_user!
  skip_before_action :only_my_collection

  def show
    super
  end

  private

  def collection
    @collection ||=
      Collection.find_by_share_id(params[:id]).tap do |c|
        handle_collection_not_found if c.blank?
      end
  end

  def handle_collection_not_found
    respond_to do |format|
      # TODO: Redirect to a 404 page here
      format.html { redirect_to root_path }
      format.json { render json: {}, status: 400 }
    end
  end

  def handle_not_my_collection
    respond_to do |format|
      # TODO: Redirect to a 404 page here
      format.html { redirect_to root_path }
      format.json { render json: {}, status: 400 }
    end
  end
end
