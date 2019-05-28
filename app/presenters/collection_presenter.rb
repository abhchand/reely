class CollectionPresenter < ApplicationPresenter
  def photo_grid_props
    {
      id: synthetic_id,
      name: name
    }
  end
end
