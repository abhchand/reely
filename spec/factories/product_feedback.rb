FactoryBot.define do
  factory :product_feedback do
    user
    sequence(:body) { |i| "Feedback ##{i}" }
  end
end
