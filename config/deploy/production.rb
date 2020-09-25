# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server ENV['DEPLOY_SERVER'], user: 'deploy', roles: %w[web app], primary: true
