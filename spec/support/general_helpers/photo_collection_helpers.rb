module GeneralHelpers
  def create_collection_with_photos(opts = {})
    owner = opts[:owner] || create(:user)
    collection = create(:collection, owner: owner)

    photo_count = opts[:photo_count] || 2
    photos = create_list(:photo, photo_count, owner: owner)

    photos.each do |photo|
      create(:photo_collection, photo: photo, collection: collection)
    end

    collection
  end
end
