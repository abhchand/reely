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

  describe "notify_inviter_of_completion" do
    let(:mail) do
      UserInvitationMailer.notify_inviter_of_completion(@user_invitation.id)
    end

    let(:inviter) { create(:user) }
    let(:invitee) { create(:user) }

    before do
      @user_invitation = create(
        :user_invitation,
        inviter: inviter,
        invitee: invitee
      )
      @t_prefix = "user_invitation_mailer.notify_inviter_of_completion"
    end

    it "sends the email to the user" do
      expect(mail.from).to eq([ENV["EMAIL_FROM"]])
      expect(mail.to).to eq([inviter.email])
      expect(mail.subject).to eq(
        t("#{@t_prefix}.subject", invitee_name: invitee.name)
      )
    end

    it "displays the invitee's name" do
      expect(mail.body).to have_content(@user_invitation.invitee.name)
    end

    it "displays the admin index url" do
      url = admin_index_url
      expect(mail.body).to have_link("admin panel", href: url)
    end
  end
end
