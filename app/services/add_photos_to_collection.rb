class AddPhotosToCollection
  include Interactor

  def call
    each_photo do |photo|
      photo_collection = build_photo_collection(photo)

      unless photo_collection.save
        @failure = true
        raise ActiveRecord::Rollback
      end
    end

    check_for_failure!
  end

  private

  def collection
    @collection ||= context.collection
  end

  def photo_synthetic_ids
    @photo_synthetic_ids ||= (context.params[:photo_ids] || []).uniq
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def each_photo(&block)
    PhotoCollection.transaction do
      photo_synthetic_ids.each_slice(50) do |synthetic_ids|
        whitelist_photos(synthetic_ids).each do |photo|
          yield(photo)
        end
      end
    end
  end
  # rubocop:enable Lint/UnusedMethodArgument

  def whitelist_photos(synthetic_ids)
    Photo.
      select(:id, :owner_id).
      joins(
        <<-SQL
        LEFT JOIN photo_collections
          ON photo_collections.photo_id = photos.id
          AND photo_collections.collection_id = #{collection.id}
        SQL
      ).
      where(synthetic_id: synthetic_ids).
      where(photo_collections: { id: nil })
  end

  def build_photo_collection(photo)
    PhotoCollection.new(photo: photo, collection: collection).tap do |pc|
      # The `PhotoCollection` model validates that the asosciated `:photo`
      # and `:collection` both have the same owner before saving.
      #
      # To avoid it querying for both associations individually on each
      # record that we are trying to save, we preload the associations manually
      # here by assigning them directly.
      #
      # The only field that needs to be accessed on both the associated `Photo`
      # and `Collection` is the `owner_id` field. For `Collection` the entire
      # model is alreayd loaded. For each `Photo`, we ensure that `:owner_id`
      # is selected/fetched in the query above.
      photo_assoc = pc.association(:photo)
      photo_assoc.target = photo

      collection_assoc = pc.association(:collection)
      collection_assoc.target = collection
    end
  end

  def check_for_failure!
    context.fail! if @failure
  end
end
