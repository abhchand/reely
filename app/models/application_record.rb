class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def serialize_errors
    errors_json = []

    errors.messages.each do |field, messages|
      messages.each do |message|
        # NOTE: Errors not visible to end users are not translated
        errors_json << {
          title: "Invalid #{field}",
          description: message,
          status: "403"
        }
      end
    end

    { errors: errors_json, status: "403" }
  end
end
