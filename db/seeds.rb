# Create a user
user = FactoryBot.create(
  :user,
  with_avatar: true,
  first_name: "Sindhu",
  last_name: "Iyer",
  email: "test@example.com",
  password: "test!123"
)

# Import each photo under the test path
photos = Dir[Rails.root.join("public/images/test/**.jpg")]

photos.each_with_index do |photo, i|
  puts "Creating photo #{i + 1} of #{photos.count}"

  FactoryBot.create(
    :photo,
    owner: user,
    source: File.new(photo),
    taken_at: (10 * i).days.from_now
  )
end

# Create Collections
5.times do
  collection = FactoryBot.create(:collection, owner: user)

  Photo.all.sample(5).each do |photo|
    FactoryBot.create(:photo_collection, photo: photo, collection: collection)
  end
end
