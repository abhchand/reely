FactoryBot.define do
  factory :user do
    transient do
      with_avatar { false }
      avatar_name { "avatar.png" }
      add_admin_role { false }
    end

    sequence(:email) { |n| "alonzo-#{n}@lapd.gov" }
    first_name { "Alonzo" }
    last_name { "Harris" }
    password { FeatureHelpers::DEFAULT_PASSWORD }
    confirmed_at { Time.zone.now }
    confirmation_token { Devise.friendly_token }

    trait(:native) do
      password { FeatureHelpers::DEFAULT_PASSWORD }
      confirmed_at { Time.zone.now }
      confirmation_token { Devise.friendly_token }
    end

    trait(:omniauth) do
      password { nil }
      confirmed_at { nil }
      confirmation_token { nil }
      provider { User::OMNIAUTH_PROVIDERS.first }
      sequence(:uid) { |n| n.to_s.rjust(8, "0") }
    end

    trait(:unconfirmed) do
      confirmed_at { nil }
      confirmation_token { nil }
      confirmation_sent_at { nil }
    end

    trait(:pending_reconfirmation) do
      unconfirmed_email { "unconfirmed@xyz.com" }
    end

    trait(:deactivated) do
      deactivated_at { Time.zone.now }
    end

    trait(:admin) do
      add_admin_role { true }
    end

    after(:create) do |user, e|
      if e.with_avatar
        file = File.open(Rails.root + "spec/fixtures/images/#{e.avatar_name}")
        user.avatar.attach(io: file, filename: e.avatar_name)
      end

      if e.add_admin_role
        user.add_role(:admin)
      end
    end
  end
end
