domain =
  if Rails.env.production?
    ENV.fetch("APP_HOST")
  else
    ENV.fetch("APP_HOST", "localhost")
  end

SMTP_SETTINGS = {
  user_name: ENV["SENDGRID_USERNAME"],
  password:  ENV["SENDGRID_PASSWORD"],
  domain: domain,
  address: "smtp.sendgrid.net",
  port: "587",
  authentication: :plain,
  enable_starttls_auto: true
}.freeze
