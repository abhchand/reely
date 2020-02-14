class CollectionPresenter < ApplicationPresenter
  def photo_manager_props
    as_json(include: %(share_id))
  end
end
