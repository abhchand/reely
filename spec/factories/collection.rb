FactoryBot.define do
  factory :collection do
    owner factory: :user
    sequence(:name) { |i| "Collection ##{i}" }
  end
end
