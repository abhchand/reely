FactoryBot.define do
  factory :photo do
    transient do
      with_source_file { true }
      source_file_name { "atlanta.jpg" }
    end

    owner factory: :user
    exif_data { {} }
    taken_at { Time.now }
    latitude { 0.0000 }
    longitude { 0.0000 }

    after(:create) do |photo, e|
      if e.with_source_file
        file =
          File.open(Rails.root + "spec/fixtures/images/#{e.source_file_name}")

        photo.source_file.attach(io: file, filename: e.source_file_name)
      end
    end
  end
end
