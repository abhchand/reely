def registration_email_domain_whitelist_enabled?
  ENV["REGISTRATION_EMAIL_DOMAIN_WHITELIST"].present?
end

def registration_email_whitelisted_domains
  ENV["REGISTRATION_EMAIL_DOMAIN_WHITELIST"].split(",").map(&:strip).uniq
end
