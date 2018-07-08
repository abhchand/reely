FactoryGirl.define do
  factory :photo do
    owner factory: :user
    source File.new(Rails.root + "spec/fixtures/images/san-francisco.jpg")
    taken_at Time.zone.now
    width 100
    height 100
    latitude 0.0000
    longitude 0.0000
  end
end
