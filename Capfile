# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# RVM tasks
require "capistrano/rvm"

# Bundler tasks
require "capistrano/bundler"

# Rails tasks
require "capistrano/rails/assets"
require "capistrano/rails/migrations"

# Load custom tasks and helpers
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
Dir.glob("lib/capistrano/**/*.rb").each { |r| import r }
