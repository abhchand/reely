def native_auth_enabled?
  return true unless ENV.key?("NATIVE_AUTH_ENABLED")

  ActiveRecord::Type::Boolean.new.deserialize(ENV["NATIVE_AUTH_ENABLED"])
end
