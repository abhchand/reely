FactoryGirl.define do
  factory :collection do
    owner factory: :user
    name "My cool Collection"
  end
end
