module CollectionHelper
  def collection
    @collection ||= begin
      id = params[:collection_id] || params[:id]
      Collection.find_by_synthetic_id(id).tap do |c|
        handle_collection_not_found if c.blank?
      end
    end
  end

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def shared_collection
    @collection ||= begin
      id = params[:collection_id] || params[:id]
      Collection.find_by_share_id(id).tap do |c|
        handle_collection_not_found if c.blank?
      end
    end
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def only_my_collection
    return if current_user.owns_collection?(@collection)
    handle_not_my_collection
  end

  def handle_collection_not_found
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: {}, status: 400 }
    end
  end

  def handle_not_my_collection
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: {}, status: 400 }
    end
  end
end
