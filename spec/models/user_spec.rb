require "rails_helper"
# rubocop:disable Metrics/LineLength
require Rails.root.join("spec/support/shared_examples/models/concerns/has_synthetic_id").to_s
# rubocop:enable Metrics/LineLength

RSpec.describe User do
  it_behaves_like "has synthetic id"

  subject { build(:user) }
  let(:user) { build(:user) }

  describe "Associations" do
    it { should have_many(:photos) }
    it { should have_many(:collections) }
    it { should have_many(:shared_collection_recipients) }
    it do
      should have_many(:received_collections).
        through(:shared_collection_recipients)
    end
  end

  describe "validations" do
    subject { build(:user) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    describe "email" do
      # Uniqueness check requires persited records to compare. Non persisted
      # records fail for having an un-generated (NULL) `synthetic_id`
      subject { create(:user) }

      # Devise
      it { should validate_presence_of(:email) }

      # Devise
      it { should validate_uniqueness_of(:email).case_insensitive }

      # Devise
      it "validates format" do
        ["abcd@xyz.com", "ab.cd@xyz.com", "ABCD@xyz.com"].each do |value|
          should allow_value(value).for(:email)
        end

        ["@xyz.com", "abcd@xyz", "", "abcdxyz"].each do |value|
          should_not allow_value(value).for(:email)
        end
      end

      describe "registration is restricted by domain" do
        before do
          stub_env("REGISTRATION_EMAIL_DOMAIN_WHITELIST" => "example.com,x.yz")
        end

        it "allows valid email domains" do
          user.email = "me@x.yz"

          expect(user).to be_valid
        end

        it "disallows invalid email domains" do
          user.email = "me@me.gov"

          expect(user).to_not be_valid

          error =
            validation_error_for(:email, :invalid_domain, domain: "me.gov")
          expect(user.errors.messages[:email].first).to eq(error)
        end

        it "handles blank and invalid emails" do
          user.email = ""

          expect(user).to_not be_valid
          expect(user.errors.added?(:email, :invalid_domain)).to eq(false)

          user.email = "abcdefg"

          expect(user).to_not be_valid
          expect(user.errors.added?(:email, :invalid_domain)).to eq(false)
        end

        it "is case insensitive" do
          user.email = "FOO@EXAMPLE.COM"

          expect(user).to be_valid
        end

        it "handles whitespace in the whitelist" do
          stub_env("REGISTRATION_EMAIL_DOMAIN_WHITELIST" => "example.com, x.yz")
          user.email = "me@x.yz"

          expect(user).to be_valid
        end
      end
    end

    # NOTE: `password` is a synthetic model field tracked by Devise which
    # stores data in the underlying `#encrypted_password` field
    describe "password" do
      context "native" do
        # Devise
        it do
          # Shoulda's `validate_presence_of` matcher doesn't work here
          expect(user.send(:password_required?)).to eq(true)
          user.password = nil

          user.valid?

          expect(user.errors.added?(:password, :blank)).to eq(true)
        end

        # Devise
        it do
          # Shoulda's `validate_confirmation_of` matcher doesn't work here
          # because it doesn't correctly translate the error and looks instead
          # for the default error translation instead of our custom one

          user.password = "Indian!Ocean7"
          user.password_confirmation = "Pacific!Ocean7"

          user.valid?

          error = [:confirmation, attribute: "Password"]
          expect(user.errors.added?(:password_confirmation, *error)).to eq(true)
        end

        # Devise
        it { should validate_length_of(:password) }

        describe "#additional_password_requirements" do
          it "allows valid passwords" do
            user.password = "Indian!Ocean7"
            expect(user).to be_valid
          end

          it "errors on invalid passwords" do
            ["Ind", "7777!777", "IndianOcean7"].each do |bad_password|
              user.password = bad_password
              user.valid?

              error = validation_error_for(:password, :invalid)
              # Ensure this error is listed first, superceding other errors
              expect(user.errors.messages[:password].first).to eq(error)
            end
          end
        end
      end

      context "omniauth" do
        subject(:user) { build(:user, :omniauth) }

        it { should validate_absence_of(:password) }
      end
    end

    describe "#encrypted_password" do
      context "native" do
        it { should validate_presence_of(:encrypted_password) }

        describe "#encrypted_password_is_valid_bcrypt_hash" do
          it "errors when encrypted_password is not a valid bcrypt hash" do
            user.encrypted_password = "foo"
            user.valid?

            error = validation_error_for(:encrypted_password, :invalid)
            expect(user.errors.messages[:encrypted_password].first).to eq(error)
          end
        end
      end

      context "omniauth" do
        subject { build(:user, :omniauth) }

        it { should validate_absence_of(:encrypted_password) }
      end
    end

    it { should validate_presence_of(:sign_in_count) }

    describe "provider" do
      it do
        should(
          validate_inclusion_of(:provider).in_array(User::OMNIAUTH_PROVIDERS)
        )
      end
      it { should allow_value(nil).for(:provider) }
    end

    describe "reset_password_token" do
      context "native" do
        it { should_not validate_absence_of(:reset_password_token) }
      end

      context "omniauth" do
        subject { build(:user, :omniauth) }

        it { should validate_absence_of(:reset_password_token) }
      end
    end

    describe "reset_password_sent_at" do
      context "native" do
        it { should_not validate_absence_of(:reset_password_sent_at) }
      end

      context "omniauth" do
        subject { build(:user, :omniauth) }

        it { should validate_absence_of(:reset_password_sent_at) }
      end
    end

    describe "confirmation_token" do
      context "native" do
        it { should_not validate_absence_of(:confirmation_token) }
      end

      context "omniauth" do
        subject { build(:user, :omniauth) }

        it { should validate_absence_of(:confirmation_token) }
      end
    end

    describe "confirmed_at" do
      context "native" do
        it { should_not validate_absence_of(:confirmed_at) }
      end

      context "omniauth" do
        subject { build(:user, :omniauth) }

        it { should validate_absence_of(:confirmed_at) }
      end
    end

    describe "confirmation_sent_at" do
      context "native" do
        it { should_not validate_absence_of(:confirmation_sent_at) }
      end

      context "omniauth" do
        subject { build(:user, :omniauth) }

        it { should validate_absence_of(:confirmation_sent_at) }
      end
    end

    describe "uid" do
      context "native" do
        it { should validate_absence_of(:uid) }
      end

      context "omniauth" do
        # Uniqueness check requires persited records to compare. Non persisted
        # records fail for having an un-generated (NULL) `synthetic_id`
        subject { create(:user, :omniauth) }

        it { should validate_presence_of(:uid) }
        it { should validate_uniqueness_of(:uid).case_insensitive }
      end
    end
  end

  describe "callbacks" do
    describe "before_validation" do
      # Devise
      describe "#downcase_keys and #strip_whitespace" do
        it "strips and downcases email before saving" do
          user.email = "  ABCD@XyZ.CoM "
          user.valid?

          expect(user.email).to eq("abcd@xyz.com")
        end
      end
    end

    describe "before_create" do
      # Devise
      describe "#generate_confirmation_token" do
        it "does not generate a confirmation_token" do
          user.confirmation_token = nil

          expect do
            user.save!
          end.to_not(change { user.confirmation_token })
        end

        context "user is unconfirmed" do
          let(:user) { build(:user, :unconfirmed) }

          it "generates a confirmation_token" do
            user.confirmation_token = nil
            user.save!
            expect(user.confirmation_token).to_not be_nil
          end

          context "confirmation_token already exists" do
            before { user.confirmation_token = Devise.friendly_token }

            it "does not replace the existing token" do
              expect(user.confirmation_token).to_not be_nil

              expect do
                user.save!
              end.to_not(change { user.confirmation_token })
            end
          end
        end
      end
    end

    describe "before_update" do
      # Devise
      describe "#clear_reset_password_token" do
        let(:user) { create(:user) }

        before do
          user.send_reset_password_instructions

          expect(user.reset_password_token).to_not be_nil
          expect(user.reset_password_sent_at).to_not be_nil
        end

        it "clears reset password token when encrypted_password updated" do
          user.update!(password: "Some!NewPassword01#")

          expect(user.reset_password_token).to be_nil
          expect(user.reset_password_sent_at).to be_nil
        end

        it "clears reset password token when email updated" do
          user.update!(email: "something-else@foo.com")

          expect(user.reset_password_token).to be_nil
          expect(user.reset_password_sent_at).to be_nil
        end

        it "doesn't clear reset password token when other fields are updated" do
          user.update!(first_name: "Foo")

          expect(user.reset_password_token).to_not be_nil
          expect(user.reset_password_sent_at).to_not be_nil
        end
      end
    end

    describe "after_update" do
      # Devise
      describe "#send_email_changed_notification" do
        before do
          # This is controlled by a Devise config which should be set to
          # false. If this ever changes, we should write new specs :)
          expect(Devise.send_email_changed_notification).to eq(false)

          # If Devise every changes its internal mailer name, we should
          # update our spec here
          devise_mailers = Devise::Mailer.instance_methods(false)
          expect(devise_mailers).to include(:email_changed)

          user.save!
        end

        it "does not send a email changed notification on updating email" do
          user.update!(email: "something-else@foo.com")
          expect(mailer_names).to_not include(:email_changed)
        end
      end

      # Devise
      describe "#send_password_change_notification" do
        before do
          # This is controlled by a Devise config which should be set to
          # false. If this ever changes, we should write new specs :)
          expect(Devise.send_password_change_notification).to eq(false)

          # If Devise every changes its internal mailer name, we should
          # update our spec here
          devise_mailers = Devise::Mailer.instance_methods(false)
          expect(devise_mailers).to include(:password_change)

          user.save!
        end

        it "does not send a password change notice on updating password" do
          user.update!(password: "new!Password07#")
          expect(mailer_names).to_not include(:password_change)
        end
      end
    end

    describe "after_commit" do
      # Devise
      #
      # This section also combines specs for 1 other callbacks defined by us
      #
      # after_create :skip_confirmation_notification!, if: omniauth?
      #
      # This callback skips sending confirmation for omniauth logins since
      # we assume the third party service has already verified this.
      #
      describe "#send_on_create_confirmation_instructions" do
        let(:user) { build(:user, :unconfirmed) }

        it "sends confirmation instructions on create" do
          now = Time.zone.now.change(usec: 0)
          expect(user.persisted?).to eq(false)

          travel_to(now) do
            expect { user.save! }.to(change { mailer_queue.size }.by(1))
          end

          user.reload

          expect(user.confirmation_sent_at).to eq(now)

          email = mailer_queue.last
          expect(email[:klass]).to eq(Devise::Mailer)
          expect(email[:method]).to eq(:confirmation_instructions)
          expect(email[:args][:record]).to eq(user)
          expect(email[:args][:token]).to eq(user.confirmation_token)
          expect(email[:args][:opts]).to eq({})
        end

        context "not creating" do
          before do
            user.save!
            clear_mailer_queue
          end

          it "does not send confirmation instructions" do
            expect do
              user.update!(first_name: "Foo")
            end.to_not(change { mailer_queue.size })
          end
        end

        context "omniauth" do
          let(:user) { build(:user, :omniauth) }

          it "does not send confirmation instructions" do
            expect { user.save! }.to_not(change { mailer_queue.size })
          end
        end

        context "user does not have a confirmation_token" do
          before { user.confirmation_token = nil }

          it "generates one before sending the confirmation instructions" do
            expect { user.save! }.to(change { mailer_queue.size }.by(1))
            expect(user.confirmation_token).to_not be_nil
          end
        end

        context "user is already confirmed" do
          let(:user) { build(:user) }

          before { expect(user.confirmed?).to eq(true) }

          it "does not send confirmation instructions" do
            expect { user.save! }.to_not(change { mailer_queue.size })
          end
        end

        context "user is pending reconfirmation" do
          let(:user) { build(:user, :unconfirmed, :pending_reconfirmation) }

          it "sends confirmation instructions to the unconfirmed_email" do
            expect(user.unconfirmed_email).to_not be_nil
            expect { user.save! }.to(change { mailer_queue.size }.by(1))

            email = mailer_queue.last
            expect(email[:klass]).to eq(Devise::Mailer)
            expect(email[:method]).to eq(:confirmation_instructions)
            expect(email[:args][:record]).to eq(user)
            expect(email[:args][:token]).to eq(user.confirmation_token)
            expect(email[:args][:opts]).to eq(to: user.unconfirmed_email)
          end
        end

        context "confirmation notification is skipped" do
          before { user.skip_confirmation_notification! }

          it "does not send confirmation instructions" do
            expect { user.save! }.to_not(change { mailer_queue.size })
          end
        end
      end

      # Devise
      #
      #
      # This section also combines specs for 2 other callbacks defined by
      # Devise.
      #
      # before_update :postpone_email_change_until_confirmation_and_regenerate_confirmation_token
      # after_create :skip_reconfirmation_in_callback!
      #
      # Both these callbacks contribute to the behavior of how reconfirmation
      # notifications are sent.
      #
      # The `before_update` callback  detects if the `email` field is being
      # changed and  if so, stores the email in  `:unconfirmed_email` instead of
      # updating `:email` directly.
      #
      # The `after_create` skips sending the reconfirmation email when already
      # sending the confirmation email so that two emails don't get delivered.
      describe "#send_reconfirmation_instructions" do
        let(:user) { create(:user) }

        it "sends reconfirmation instructions when email field is updated" do
          now = Time.zone.now.change(usec: 0)

          travel_to(now) do
            expect do
              user.update!(email: "something-else@foo.com")
            end.to(change { mailer_queue.size }.by(1))
          end

          expect(user.confirmation_sent_at).to eq(now)

          email = mailer_queue.last
          expect(email[:klass]).to eq(Devise::Mailer)
          expect(email[:method]).to eq(:confirmation_instructions)
          expect(email[:args][:record]).to eq(user)
          expect(email[:args][:token]).to eq(user.confirmation_token)
          expect(email[:args][:opts]).to eq(to: "something-else@foo.com")
        end

        context "not updating email field" do
          it "does not send reconfirmation instructions" do
            expect do
              user.update!(first_name: "Foo")
            end.to_not(change { mailer_queue.size })
          end
        end

        context "not updating" do
          let(:user) { build(:user, :unconfirmed) }

          it "does not send reconfirmation instructions" do
            # Original confirmation is still sent. We're checking here
            # that a second email for reconfirmation is not sent, since
            # the `after_create` hook has logic to skip reconfirmation if
            # the initial confirmation is also being sent
            expect { user.save! }.to(change { mailer_queue.size }.by(1))
          end
        end

        context "user does not have a confirmation_token" do
          before { user.update!(confirmation_token: nil) }

          it "generates one before sending the reconfirmation instructions" do
            expect do
              user.update!(email: "something-else@foo.com")
            end.to(change { mailer_queue.size }.by(1))

            expect(user.confirmation_token).to_not be_nil
          end
        end

        context "user is pending initial confirmation" do
          let(:user) { create(:user, :unconfirmed) }

          it "still sends the reconfirmation notification" do
            # Trigger `on: :create` confirmation to go ahead and send
            user

            expect do
              user.update!(email: "something-else@foo.com")
            end.to(change { mailer_queue.size }.by(1))

            email = mailer_queue.last
            expect(email[:klass]).to eq(Devise::Mailer)
            expect(email[:method]).to eq(:confirmation_instructions)
            expect(email[:args][:record]).to eq(user)
            expect(email[:args][:token]).to eq(user.confirmation_token)
            expect(email[:args][:opts]).to eq(to: "something-else@foo.com")
          end
        end

        context "reconfirmation email is skipped" do
          before { user.skip_reconfirmation! }

          it "does not send reconfirmation instructions" do
            expect do
              user.update!(email: "something-else@foo.com")
            end.to_not(change { mailer_queue.size })
          end
        end
      end
    end

    describe "after_commit" do
      describe "#complete_user_invitation" do
        context "a user invitation exists" do
          let(:invitation) { create(:user_invitation, email: user.email) }

          it "updates the invitee on the UserInvitation record" do
            expect(invitation.invitee).to be_nil
            user.save!
            expect(invitation.reload.invitee).to eq(user)
          end
        end
      end
    end
  end

  describe "#send_reset_password_instructions" do
    # Sending password reset requires persited records to on which reset tokens
    # are generated. Non persisted records fail for having an un-generated
    # (NULL) `synthetic_id`
    let(:user) { create(:user) }

    it "sends password reset instructions" do
      expect do
        user.send_reset_password_instructions
      end.to(change { mailer_queue.count }.by(1))
    end

    context "omniauth account" do
      let(:user) { build(:user, :omniauth, provider: "google_oauth2") }

      it "does not send password reset instructions" do
        expect do
          user.send_reset_password_instructions
        end.to_not(change { mailer_queue.count })
      end

      it "adds validation errors" do
        user.send_reset_password_instructions

        provider = User.human_attribute_name("omniauth_provider.google_oauth2")
        error = validation_error_for(
          :base,
          :omniauth_not_recoverable,
          provider: provider
        )
        expect(user.errors.messages[:base].first).to eq(error)
      end
    end
  end

  describe "#name=" do
    it "splits the first and last name" do
      [
        ["Srinivasa Ramanujan", "Srinivasa", "Ramanujan"],
        ["Srinivasa Ramanujan III", "Srinivasa", "Ramanujan III"],
        ["Srinivasa", "Srinivasa", nil]
      ].each do |(full_name, first_name, last_name)|
        user.name = full_name

        expect(user.first_name).to eq(first_name)
        expect(user.last_name).to eq(last_name)
      end
    end
  end
end
