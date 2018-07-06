FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "alonzo-#{n}@lapd.gov" }
    first_name "Alonzo"
    last_name "Harris"
    password { FeatureHelpers::DEFAULT_PASSWORD }

    trait :with_avatar do
      avatar do
        File.new(Rails.root.join("spec", "fixtures", "images", "atlanta.jpg"))
      end
    end
  end
end
