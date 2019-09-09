class Collections::SharingConfigService
  def initialize(collection)
    @collection = collection
  end

  def as_json
    {
      via_link: {
        enabled: link_sharing_enabled?,
        url: link_sharing_url
      }
    }
  end

  def update(params)
    str_params = params.to_h.deep_stringify_keys

    @collection.sharing_config.deep_merge!(str_params)
    @collection.save
  end

  private

  def link_sharing_enabled?
    @collection.sharing_config["link_sharing_enabled"].present?
  end

  def link_sharing_url
    Rails.application.routes.url_helpers.collections_sharing_display_url(
      id: @collection.share_id
    )
  end
end
