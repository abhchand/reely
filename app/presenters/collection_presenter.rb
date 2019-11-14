class CollectionPresenter < ApplicationPresenter
  def photo_manager_props
    {
      id: synthetic_id,
      name: name
    }
  end
end
