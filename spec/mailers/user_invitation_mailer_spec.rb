require "rails_helper"

RSpec.describe UserInvitationMailer do
  let(:hostname) { BaseSendgridMailer.send(:new).send(:hostname) }

  describe "invite" do
    let(:mail) { UserInvitationMailer.invite(@user_invitation.id) }

    before do
      @user_invitation = create(:user_invitation)
      @t_prefix = "user_invitation_mailer.invite"
    end

    it "sends the email to the user" do
      expect(mail.from).to eq([ENV["EMAIL_FROM"]])
      expect(mail.to).to eq([@user_invitation.email])
      expect(mail.subject).to eq(t("#{@t_prefix}.subject"))
    end

    it "displays the inviter's name" do
      expect(mail.body).to have_content(@user_invitation.inviter.name)
    end

    it "displays the url" do
      url = new_user_registration_url
      expect(mail.body).to have_link(url, href: url)
    end
  end
end
