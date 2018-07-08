# Create a user
FactoryGirl.create(
  :user,
  :with_avatar,
  first_name: "Sindhu",
  last_name: "Iyer",
  email: "test@example.com",
  password: "test"
)

# Import each photo under the test path
photos = Dir[Rails.root.join("public/images/test/**.jpg")]

photos.each_with_index do |photo, i|
  puts "Creating photo #{i + 1} of #{photos.count}"
  FactoryGirl.create(
    :photo,
    source: File.new(photo),
    taken_at: i.months.from_now
  )
end
