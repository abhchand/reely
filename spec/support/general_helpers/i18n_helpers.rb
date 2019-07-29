module GeneralHelpers
  def validation_error_for(attribute, key, opts = {})
    opts[:klass] ||= User
    klass = opts.delete(:klass)

    path = [
      "activerecord.errors.models",
      klass.name.underscore,
      "attributes",
      attribute,
      key
    ].join(".")

    I18n.t(path, opts)
  end
end
