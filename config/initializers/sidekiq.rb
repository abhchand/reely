require "sidekiq/web"

unless defined? SidekiqRedisConnectionWrapper
  Sidekiq::Logging.logger = Rails.logger

  class SidekiqRedisConnectionWrapper
    # rubocop:disable Style/IfUnlessModifier
    unless defined? URL
      URL = ENV["REDISTOGO_URL"] || "redis://localhost:6379/"
    end
    # rubocop:enable Style/IfUnlessModifier

    def initialize
      Sidekiq.configure_server do |config|
        config.redis = { url: URL, network_timeout: 3 }
      end

      Sidekiq.configure_client do |config|
        conn_pool_size = ENV["SIDEKIQ_CLIENT_POOL_SIZE"] || 3
        config.redis = { url: URL, network_timeout: 3, size: conn_pool_size }
      end
    end

    # rubocop:disable Style/MethodMissingSuper
    def method_missing(meth, *args, &block)
      Sidekiq.redis do |connection|
        connection.send(meth, *args, &block)
      end
    end
    # rubocop:enable Style/MethodMissingSuper

    def respond_to_missing?(meth)
      Sidekiq.redis do |connection|
        connection.respond_to?(meth)
      end
    end
  end
end
