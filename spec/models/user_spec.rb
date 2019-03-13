require "rails_helper"

RSpec.describe User do
  describe "Associations" do
    it { should have_many(:photos) }
    it { should have_many(:collections) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    describe "email" do
      it { should validate_presence_of(:email) }

      it "validates the format" do
        should allow_value("x@y.com").for(:email)
        should_not allow_value("x@y").for(:email)
        should_not allow_value("xy").for(:email)
      end
    end
  end

  describe "callbacks" do
    describe "before_validation" do
      describe "#encrypt_password_with_salt" do
        let(:password) { "foo" }
        let(:user) { create(:user, password: password) }

        it "encrypts the password and stores the salt before saving" do
          expect(user.password_salt).to_not be_nil
          expect(user.password).to eq(
            BCrypt::Engine.hash_secret("foo", user.password_salt)
          )
        end

        it "does not re-encrypt the password while updating other attributes" do
          old_password = user.password
          old_password_salt = user.password_salt

          user.update(email: "xyz@gmail.com")

          expect(user.password).to eq(old_password)
          expect(user.password_salt).to eq(old_password_salt)
        end
      end
    end

    describe "before_save" do
      describe "#lower_email_case" do
        it "saves the email as lower case" do
          email = "FOO@GMAIL.COM"
          user = create(:user)
          user.update(email: email)
          expect(user.reload.email).to eq(email.downcase)
        end
      end

      describe "#strip_email" do
        it "strips the email before saving" do
          email = "foo@gmail.com"
          user = create(:user)
          user.update(email: "#{email}  ")
          expect(user.reload.email).to eq(email)
        end
      end
    end
  end

  describe "#password=" do
    it "updates the password and salt" do
      user = create(:user)
      old_password_salt = user.password_salt

      user.update(password: "xyz")

      new_password = BCrypt::Engine.hash_secret("xyz", user.password_salt)

      expect(user.password_salt).to_not eq(old_password_salt)
      expect(user.password).to eq(new_password)
    end
  end

  describe "#correct_password?" do
    let(:user) { create(:user, password: "foo") }

    it "returns true when the password is correct" do
      expect(user.correct_password?("foo")).to be_truthy
    end

    it "returns false when the password is not correct" do
      expect(user.correct_password?("bar")).to be_falsey
    end
  end

  describe "#avatar_path" do
    let(:user) { create(:user, with_avatar: true) }

    it "returns the avatar url based on the size" do
      # No size specified
      expect(user.avatar_path).to eq(avatar_path_for(user))

      # Size specified
      expect(user.avatar_path(size: :thumb)).
        to eq(avatar_path_for(user, size: :thumb))
    end

    context "no avatar attached" do
      let(:user) { create(:user) }

      it "returns the default blank avatar based on the size" do
        # No size specified
        expect(user.avatar_path).to eq("/assets/blank-avatar-medium.jpg")

        # Size specified
        expect(user.avatar_path(size: :thumb)).
          to eq("/assets/blank-avatar-thumb.jpg")
      end
    end
  end

  def avatar_path_for(user, size: nil)
    transformations = User::AVATAR_SIZES[size] || {}
    variant = user.avatar.variant(transformations)

    Rails.application.routes.url_helpers.
      rails_representation_url(variant, only_path: true)
  end
end
