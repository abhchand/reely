class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def serialize_errors
    errors_json = []

    errors.full_messages.each do |message|
      # NOTE: Errors not visible to end users are not translated
      # so we don't translate `:title`
      # Also, ActiveRecord generates `full_messages` by concatenating
      # the field name with the message, so the first word should always
      # be the field name
      errors_json << {
        title: "Invalid #{message.split(' ').first}",
        description: message,
        status: "403"
      }
    end

    { errors: errors_json, status: "403" }
  end
end
