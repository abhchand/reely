class RemovePhotosFromCollection
  include Interactor

  BATCH_SIZE = 50

  # Removes a list of photos from a given collection
  #
  # * `context.params[:photo_ids]` - List of `Photo` synthetic ids
  # * `context.collection` - Collection to remove from
  #
  # Behavior:
  #
  # * This class does not verify the `Collection` owner. It is assumed
  #   that some invoking class has already approved ownership of this collection
  # * This class does not verify the `Photo` owner. See comment in
  #   `each_photo_batch` below
  # * The removal of all photos is atomic - any raised error rolls back
  #   all photo removals

  def call
    each_photo_batch do |photo_ids|
      # rubocop:disable Style/RedundantBegin
      begin
        PhotoCollection.
          where(collection: collection, photo_id: photo_ids).destroy_all
      rescue StandardError
        @failure = true
        raise ActiveRecord::Rollback
      end
      # rubocop:enable Style/RedundantBegin
    end

    check_for_failure!
  end

  after do
    photos = collection.photos.order(:taken_at)

    context.meta = {
      date_range_label: DateRangeLabelService.call(photos),
      photo_count: photos.count
    }
  end

  private

  def collection
    @collection ||= context.collection
  end

  def photo_synthetic_ids
    @photo_synthetic_ids ||= (context.params[:photo_ids] || []).uniq
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def each_photo_batch(&block)
    PhotoCollection.transaction do
      photo_synthetic_ids.each_slice(BATCH_SIZE) do |synthetic_ids|
        # The `PhotoCollection` model validates that the asosciated `:photo`
        # and `:collection` both have the same owner before saving.
        # So we assume here that no photo could have improperly been added to
        # a collection and therefore we don't need further validation. We
        # blindly select all photos with valid synthetic ids for deletion.
        photo_ids =
          Photo.select(:id).where(synthetic_id: synthetic_ids).pluck(:id)
        yield(photo_ids)
      end
    end
  end
  # rubocop:enable Lint/UnusedMethodArgument

  def check_for_failure!
    context.fail! if @failure
  end
end
