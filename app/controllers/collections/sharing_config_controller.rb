class Collections::SharingConfigController < ApplicationController
  # ActionPack automatically translates incoming boolean `params` to
  # Strings ("true", "false"). The following boolean keys will be converted
  # back to boolean values when read as params
  BOOLEAN_SHARING_CONFIGS = %w[link_sharing_enabled].freeze

  include CollectionHelper

  before_action :ensure_json_request
  before_action :set_collection
  before_action :only_if_my_collection

  def show
    render json: sharing_config.as_json, status: 200
  end

  def update
    success = sharing_config.update(update_params)

    render(
      json: success ? sharing_config.as_json : nil, status: success ? 200 : 500
    )
  end

  def renew_link
    collection.share_id = nil
    collection.generate_share_id

    collection.save.tap do |success|
      render(
        json: success ? sharing_config.as_json : nil,
        status: success ? 200 : 500
      )
    end
  end

  private

  def sharing_config
    @sharing_config ||= Collections::SharingConfigService.new(collection)
  end

  def update_params
    params.permit(:collection_id, :link_sharing_enabled).tap do |p|
      BOOLEAN_SHARING_CONFIGS.each do |config|
        p[config] = to_bool(p[config]) if p.key?(config)
      end
    end
  end
end
