require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.configure { |config| config.before(:each) { Sidekiq::Worker.clear_all } }
