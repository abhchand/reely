module GeneralHelpers
  RSpec::Matchers.define :have_action_notification do |expected_text|
    match do |page|
      @text = expected_text

      begin
        wait_for do
          notifications = page.all(".action-notifications .notification")

          notifications.any? do |notification|
            classes =  (notification["class"] || "").split(" ")
            class_name = "notification--#{@type}"

            notification.find("span").text == @text &&
              (@type.nil? || classes.include?(class_name))
          end
        end
      rescue Timeout::Error
        return false
      end

      true
    end

    chain(:of_type) { |type| @type = type.to_sym }

    description do
      "have action notification"
    end

    failure_message do
      str = "expected notification with text '#{@text}'"
      str += " of type '#{@type}'" if @type

      str
    end
  end
end
