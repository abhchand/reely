module GeneralHelpers
  RSpec::Matchers.define :have_flash_message do |msg|
    match do |page|
      flash = page.find('.flash')
      @actual = flash.text

      @has_message =
        msg.nil? ? @actual.present? : @actual =~ /#{Regexp.quote(msg)}/i
      @has_type = @type.nil? || flash['class'].split(' ').include?(@type.to_s)

      @has_message && @has_type
    end

    chain(:of_type) { |type| @type = type }

    description { "have flash message #{msg}" }

    failure_message do |actual|
      [
        'Expected to find flash message',
        ("'#{msg}" if msg),
        ("(type: #{@type})" if @type),
        "in '#{actual}'"
      ].compact.join(' ')
    end

    failure_message_when_negated do |actual|
      [
        'Expected to NOT find flash message',
        ("'#{msg}" if msg),
        ("(type: #{@type})" if @type),
        "in '#{actual}'"
      ].compact.join(' ')
    end
  end
end
