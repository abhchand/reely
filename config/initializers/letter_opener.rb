if Rails.env.development?
  LetterOpener.configure do |config|
    # To override the location for message storage.
    # Default value is tmp/letter_opener
    config.location = Rails.root.join("tmp", "letter_opener")

    # :light - renders only the message body, without any metadata, containers,
    #          or styling.
    # :default - renders styled message with showing useful metadata (default)
    config.message_template = :default
  end
end
