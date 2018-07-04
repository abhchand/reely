FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "alonzo-#{n}@lapd.gov" }
    first_name "Alonzo"
    last_name "Harris"
    password { FeatureHelpers::DEFAULT_PASSWORD }
  end
end
