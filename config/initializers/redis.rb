require_relative "sidekiq"

$redis = Rails.env.test? ? MockRedis.new : SidekiqRedisConnectionWrapper.new
