# Ensure config is only valid for current version of Capistrano
lock "3.5.0"

set :application, "reely"

# User Setup
REELY_USER = "deploy".freeze
set :user, REELY_USER

# Deploy configuration
DEPLOY_ROOT = "/home/deploy/reely".freeze
set :ssh_options, user: REELY_USER
set :deploy_user, REELY_USER
set :deploy_to, DEPLOY_ROOT

# SCM Setup
set :scm, :git
set :repo_url, "https://github.com/abhchand/reely.git"
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp, echo: false

# RVM Setup
set :rvm_type, :system # Forces rvm to look in /usr/local/bin
set :rvm_ruby_version, "2.2.2"

# Minimize space, keep only 3 releases
set :keep_releases, 3

# Set files and directories we want to symlink into the shared folder
set(
  :linked_dirs,
  %w[
    log
    tmp/pids
    tmp/cache
    tmp/sockets
    vendor/bundle
    public/system
    public/assets
  ]
)

# Use cloned cache instead of re-cloning for each release
set :deploy_via, :remote_cache

#
# Puma Integration
#

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, "deploy:restart"
  after :finishing, "deploy:cleanup"
end
