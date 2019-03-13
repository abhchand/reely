FactoryBot.define do
  factory :user do
    transient do
      with_avatar { false }
      avatar_name { "avatar.png" }
    end

    sequence(:email) { |n| "alonzo-#{n}@lapd.gov" }
    first_name { "Alonzo" }
    last_name { "Harris" }
    password { FeatureHelpers::DEFAULT_PASSWORD }

    after(:create) do |user, e|
      if e.with_avatar
        file = File.open(Rails.root + "spec/fixtures/images/#{e.avatar_name}")
        user.avatar.attach(io: file, filename: e.avatar_name)
      end
    end
  end
end
