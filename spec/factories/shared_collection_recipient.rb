FactoryBot.define do
  factory :shared_collection_recipient do
    collection
    association :recipient, factory: :user
  end
end
