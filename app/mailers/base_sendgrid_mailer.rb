class BaseSendgridMailer < ApplicationMailer
  helper_method :namespace_url

  class MissingSubject < StandardError; end

  private

  def send_mail(opts = {})
    build_smptapi_header
    raise MissingSubject if @subject.blank?

    mail({
      to: @recipient,
      from: @from || ENV["EMAIL_FROM"],
      reply_to: @from || ENV["EMAIL_FROM"],
      subject: @subject,
      content_type: "text/html",
      # See config/initializers/devise_mailers.rb which defines similar
      # configuration for Devise mailers
      template_path: ["mailers/shared", "mailers/#{mailer_class_name}"]
    }.merge(opts))
  end

  def smtpapi_header
    @smtpapi_header ||= Smtpapi::Header.new
  end

  def build_smptapi_header
    smtpapi_header_add_category

    headers["X-SMTPAPI"] = smtpapi_header.to_json
  end

  def smtpapi_header_add_category
    smtpapi_header.add_category(action_name)
  end

  def mailer_class_name
    self.class.to_s.underscore
  end
end
