# Create a user
user = FactoryGirl.create(
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
    owner: user,
    source: File.new(photo),
    taken_at: (10 * i).days.from_now
  )
end

# Create Collections
5.times do
  collection = FactoryGirl.create(:collection, owner: user)

  Photo.all.sample(5).each do |photo|
    FactoryGirl.create(:photo_collection, photo: photo, collection: collection)
  end
end
