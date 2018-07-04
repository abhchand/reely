# Change to match your CPU core count
workers Integer(ENV["PUMA_WORKERS"] || 2)

# Min and Max threads per worker
threads 1, Integer(ENV["PUMA_MAX_THREADS"] || 5)

# Set Environment
rails_env = ENV["RAILS_ENV"] || "development"
environment(rails_env)

# Set directories
app_root = File.expand_path("../..", __FILE__)
tmp_dir = "#{app_root}/tmp"
log_dir = "#{app_root}/log"
# Locally the shared directory is under the app root, but on remote servers
# Capistrano symlinks each release to a shared/ directory
shared_dir =
  if ["staging", "production"].include?(rails_env)
     "/home/deploy/reely/shared"
  else
    "#{app_root}/shared"
  end

# Set up socket location
bind "unix://#{tmp_dir}/sockets/puma.sock"

# Logging
if %w(production).include?(rails_env)
  stdout_redirect "#{log_dir}/puma.stdout.log", "#{log_dir}/puma.stderr.log", true
end

# Set master PID and state locations
pidfile "#{tmp_dir}/pids/puma.pid"
state_path "#{tmp_dir}/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_root}/config/database.yml")[rails_env])
end
