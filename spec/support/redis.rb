RSpec.configure { |config| config.before(:each) { $redis.flushall } }
