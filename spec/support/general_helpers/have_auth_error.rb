module GeneralHelpers
  RSpec::Matchers.define :have_auth_error do |expected|
    match do |page|
      @messages = page.all(".auth__form-errors li").map(&:text)
      @messages.include?(expected)
    end

    description do
      "have auth error message #{expected}"
    end

    failure_message do
      [
        "Expected to find",
        "'#{expected}'",
        "in",
        "'#{@messages.join(' ')}'"
      ].join(" ")
    end
  end
end
