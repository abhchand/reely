# Set Environment
rails_env = ENV["RAILS_ENV"] || "development"
is_remote = !%w[test development].include?(rails_env)
environment(rails_env)

# Directories
app_root = File.expand_path("..", __dir__)
tmp_dir = "#{app_root}/tmp"

# Load dotenv file(s) manually
require "dotenv"
Dotenv.load("#{app_root}/.env.#{rails_env}", "#{app_root}/.env")

# Change to match your CPU core count
workers Integer(ENV["PUMA_WORKERS"] || 2)

# Min and Max threads per worker
threads 1, Integer(ENV["PUMA_MAX_THREADS"] || 5)

# Socket
if is_remote
  socket_dir = tmp_dir + "/sockets"
  system "mkdir", "-p", socket_dir
  bind "unix://#{socket_dir}/puma.sock"
end

# Logging
if is_remote
  log_dir = "#{app_root}/log"
  stdout_redirect(
    "#{log_dir}/puma.stdout.log",
    "#{log_dir}/puma.stderr.log",
    true
  )
end

# PID
pid_dir = tmp_dir + "/pids"
system "mkdir", "-p", pid_dir
pidfile "#{pid_dir}/puma.pid"
state_path "#{pid_dir}/puma.state"
activate_control_app

# Workers
on_worker_boot do
  require "active_record"

  # rubocop:disable LineLength, RescueModifier
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  # rubocop:enable LineLength, RescueModifier

  configs = ActiveRecord::Base.configurations[rails_env]
  ActiveRecord::Base.establish_connection(configs)
end

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
