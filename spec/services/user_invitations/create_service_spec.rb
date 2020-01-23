require "rails_helper"

RSpec.describe UserInvitations::CreateService, type: :interactor do
  let(:admin) { create(:user, :admin) }
  let(:params) do
    {
      email: "test@xyz.com"
    }
  end

  before do
    @i18n_prefix = "activerecord.errors.models.user_invitation.attributes.email"
  end

  it "creates a new user invitation" do
    result = nil
    expect { result = call }.to(change { UserInvitation.count }.by(1))

    expect(result.success?).to eq(true)

    user_invitation = result.user_invitation
    expect(user_invitation.email).to eq(params[:email])
    expect(user_invitation.inviter).to eq(admin)
    expect(user_invitation.invitee).to be_nil

    expect(result.error).to be_nil
    expect(result.log).to be_nil
    expect(result.status).to be_nil
  end

  it "audits the creation of the record" do
    result = call

    user_invitation = result.user_invitation
    audit = user_invitation.audits.last

    expect(audit.action).to eq("create")
    expect(audit.user).to eq(admin)
  end

  context "email has already been invited" do
    before { create(:user_invitation, email: params[:email]) }

    it "does not create a new UserInvitation and sets an error message" do
      result = nil
      expect { result = call }.to_not(change { UserInvitation.count })

      expect(result.success?).to eq(false)

      expect(result.error).to eq(I18n.t("#{@i18n_prefix}.already_invited"))
      expect(result.log).to_not be_nil
      expect(result.status).to eq(403)
    end

    it "is case insensitive" do
      params[:email] = params[:email].upcase

      result = nil
      expect { result = call }.to_not(change { UserInvitation.count })
    end
  end

  context "email has already been registered" do
    before { create(:user, email: params[:email]) }

    it "does not create a new UserInvitation and sets an error message" do
      result = nil
      expect { result = call }.to_not(change { UserInvitation.count })

      expect(result.success?).to eq(false)

      expect(result.error).to eq(I18n.t("#{@i18n_prefix}.already_registered"))
      expect(result.log).to_not be_nil
      expect(result.status).to eq(403)
    end

    it "is case insensitive" do
      params[:email] = params[:email].upcase

      result = nil
      expect { result = call }.to_not(change { UserInvitation.count })
    end
  end

  context "registration email domain whitelisting is enabled" do
    let(:admin) { create(:user, :admin, email: "admin@example.com") }

    before do
      stub_env("REGISTRATION_EMAIL_DOMAIN_WHITELIST" => "example.com,x.yz")
      params[:email] = "test@example.com"
    end

    it "creates a new user invitation" do
      result = nil
      expect { result = call }.to(change { UserInvitation.count }.by(1))

      expect(result.success?).to eq(true)

      user_invitation = result.user_invitation
      expect(user_invitation.email).to eq(params[:email])
      expect(user_invitation.inviter).to eq(admin)
      expect(user_invitation.invitee).to be_nil

      expect(result.error).to be_nil
      expect(result.log).to be_nil
      expect(result.status).to be_nil
    end

    context "email domain is not one of the domains whitelisted" do
      before { params[:email] = "test@foo.com" }

      it "does not create a new UserInvitation and sets an error message" do
        result = nil
        expect { result = call }.to_not(change { UserInvitation.count })

        expect(result.success?).to eq(false)

        expect(result.error).
          to eq(
            I18n.t(
              "#{@i18n_prefix}.invalid_domain",
              domains: registration_email_whitelisted_domains.join(", ")
            )
          )
        expect(result.log).to_not be_nil
        expect(result.status).to eq(403)
      end
    end
  end

  context "error saving the UserInvitation record" do
    before { allow_any_instance_of(UserInvitation).to receive(:save) { false } }

    it "does not create a new UserInvitation and sets an error message" do
      result = nil
      expect { result = call }.to_not(change { UserInvitation.count })

      expect(result.success?).to eq(false)

      expect(result.error).to eq(I18n.t("generic_error"))
      expect(result.log).to_not be_nil
      expect(result.status).to eq(500)
    end
  end

  def call(opts = {})
    UserInvitations::CreateService.call(
      { params: params, current_user: admin }.merge(opts)
    )
  end
end
