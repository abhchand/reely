require "rails_helper"

RSpec.describe Devise::Mailer do
  let(:hostname) { BaseSendgridMailer.send(:new).send(:hostname) }

  before { @user = create(:user) }

  describe "confirmation_instructions" do
    let(:mail) { Devise::Mailer.confirmation_instructions(@user, {}) }

    before { @t_prefix = "devise_mailer.users.confirmation_instructions" }

    it "generates the email" do
      expect(mail.from).to eq([ENV["EMAIL_FROM"]])
      expect(mail.to).to eq([@user.email])
      expect(mail.subject).to eq(t("#{@t_prefix}.subject"))

      expect(mail.body).
        to have_content(t("#{@t_prefix}.greeting", name: @user.email))
      expect(mail.body).to have_content(t("#{@t_prefix}.line1"))
      expect(mail.body).
        to have_link(
          t("#{@t_prefix}.confirm_email_link"),
          href: user_confirmation_url(confirmation_token: @token)
        )
    end
  end

  describe "reset_password_instructions" do
    let(:mail) { Devise::Mailer.reset_password_instructions(@user, {}) }

    before { @t_prefix = "devise_mailer.users.reset_password_instructions" }

    it "generates the email" do
      expect(mail.from).to eq([ENV["EMAIL_FROM"]])
      expect(mail.to).to eq([@user.email])
      expect(mail.subject).to eq(t("#{@t_prefix}.subject"))

      expect(mail.body).
        to have_content(t("#{@t_prefix}.greeting", name: @user.email))
      expect(mail.body).to have_content(t("#{@t_prefix}.line1"))
      expect(mail.body).
        to have_link(
          t("#{@t_prefix}.reset_password_link"),
          href: edit_user_password_url(reset_password_token: @token)
        )
      expect(mail.body).to have_content(t("#{@t_prefix}.line2"))
    end
  end
end
