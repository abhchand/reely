require 'rails_helper'
# rubocop:disable Metrics/LineLength
require Rails.root.join(
          'spec/support/shared_examples/models/concerns/has_synthetic_id'
        ).to_s
require Rails.root.join(
          'spec/support/shared_examples/models/concerns/has_direct_access_key'
        ).to_s
# rubocop:enable Metrics/LineLength

RSpec.describe Photo, type: :model do
  let(:photo) { create(:photo) }

  it_behaves_like 'has synthetic id'
  it_behaves_like 'has direct access key'

  describe 'Associations' do
    it { should belong_to(:owner) }
    it { should have_many(:photo_collections).inverse_of(:photo) }
    it { should have_many(:collections).through(:photo_collections) }
  end

  describe 'Validations' do
    describe '#exif_data' do
      it { should allow_value({}).for(:exif_data) }
      it { should allow_value(foo: :bar).for(:exif_data) }
    end

    describe '#taken_at' do
      # `taken_at` is defaulted to a value if `nil`, so validating presence
      # incorrectly passes when it should fail. Since this defaulting is
      # only done `on: :create`, we can get around this by defining a
      # `subject` that is re-used and not defaulted beyond the first validation
      # on create.
      subject { photo }

      it { should validate_presence_of(:taken_at) }
    end

    describe '#lat_long_both_blank_or_present' do
      it 'succeeds when latitude and longitude are both present' do
        photo.latitude = 38.8721
        photo.longitude = -99.3302532
        expect(photo).to be_valid
      end

      it 'succeeds when latitude and longitude are both blank' do
        photo.latitude = nil
        photo.longitude = nil
        expect(photo).to be_valid
      end

      it 'errors when only one is present' do
        photo.latitude = 38.8721
        photo.longitude = nil
        expect(photo).to_not be_valid
        expect(photo.errors.messages[:base]).to eq(
          ['latitude and longitude must both be present or blank']
        )

        photo.latitude = nil
        photo.longitude = -99.3302532
        expect(photo).to_not be_valid
        expect(photo.errors.messages[:base]).to eq(
          ['latitude and longitude must both be present or blank']
        )
      end
    end
  end

  describe 'callbacks' do
    describe 'before_validation' do
      describe '#default_taken_at' do
        let(:photo) { create(:photo, taken_at: nil, exif_data: exif_data) }

        let(:exif_data) do
          {
            'date_time_original' => '2019:03:14 13:00:00',
            'gps_latitude' => 38.8721,
            'gps_latitude_ref' => 'North',
            'gps_longitude' => -99.3302532,
            'gps_longitude_ref' => 'West'
          }
        end

        it 'only runs on: :create' do
          expect { photo.taken_at = nil }.to change {
            photo.taken_at.nil?
          }.from(false).to(true)
        end

        it 'is set from the `Date/TimeOriginal` field' do
          expect(photo.taken_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(
            '2019-03-14 13:00:00'
          )
        end

        it 'falls back on `CreateDate` second' do
          exif_data['date_time_original'] = nil
          exif_data['create_date'] = '2019:03:14 14:00:00'

          expect(photo.taken_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(
            '2019-03-14 14:00:00'
          )
        end

        it 'falls back on `GPSDateTime` third' do
          exif_data['date_time_original'] = nil
          exif_data['create_date'] = nil
          exif_data['gps_date_time'] = '2019:03:14 15:00:00'

          expect(photo.taken_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(
            '2019-03-14 15:00:00'
          )
        end

        it 'falls back on the current UTC time last' do
          now = Time.zone.parse('2000-01-01 10:00:00')

          travel_to(now) do
            exif_data['date_time_original'] = nil
            exif_data['create_date'] = nil
            exif_data['gps_date_time'] = nil

            expect(photo.taken_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(
              '2000-01-01 10:00:00'
            )
          end
        end

        context '`GPSDateTime` has a timezone' do
          it 'ignores timezone info' do
            exif_data['date_time_original'] = nil
            exif_data['create_date'] = nil
            exif_data['gps_date_time'] = '2019:03:14 15:00:00-0400'

            expect(photo.taken_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(
              '2019-03-14 15:00:00'
            )
          end
        end

        context 'taken_at is already populated' do
          it 'does not override the existing value' do
            photo.exif_data['date_time_original'] = '2001:01:01 13:00:00'
            photo.save!

            expect(photo.taken_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(
              '2019-03-14 13:00:00'
            )
          end
        end
      end

      describe '#default_lat_long' do
        let(:photo) { create(:photo, taken_at: nil, exif_data: exif_data) }

        let(:exif_data) do
          { 'gps_latitude' => 38.8721, 'gps_longitude' => -99.3302532 }
        end

        it 'only runs on: :create' do
          expect { photo.update!(latitude: nil, longitude: nil) }.to change {
            photo.latitude.nil?
          }.from(false).to(true)
        end

        it 'populates the latitude and longitude from the exif_data values' do
          expect(photo.latitude).to eq(38.8721)
          expect(photo.longitude).to eq(-99.3302532)
        end

        context 'latitude and longitude are already populated' do
          let(:photo) do
            create(
              :photo,
              taken_at: nil,
              exif_data: exif_data,
              latitude: 13.14,
              longitude: 13.14
            )
          end

          it 'does not override the existing values' do
            expect(photo.latitude).to eq(13.14)
            expect(photo.longitude).to eq(13.14)
          end
        end

        context 'only one of latitude or longitude is present in exif_data' do
          it 'does not populate latitude or longitude' do
            exif_data['gps_latitude'] = nil
            exif_data['gps_longitude'] = 13.14

            expect(photo.latitude).to be_nil
            expect(photo.longitude).to be_nil
          end
        end
      end
    end

    describe 'after_commit' do
      describe '#process_all_variants' do
        before do
          # Explicitly clear the storage before these tests since they
          # test whether variants have been processed on the disk or not and
          # we want to avoid false positives from files created during other
          # tests
          clear_storage!
        end

        context 'on attachment create' do
          it 'processes all variants' do
            photo = create(:photo, with_source_file: false)
            attach_photo_fixture(photo: photo, fixture: 'atlanta.jpg')

            expect_all_variants_processed(photo)
          end
        end

        context 'on attachment update' do
          it 'processes all variants' do
            expect_all_variants_processed(photo)

            attach_photo_fixture(photo: photo, fixture: 'chennai.jpg')
            expect_all_variants_processed(photo)
          end
        end

        context 'on attachment destroy' do
          it 'processes all variants' do
            expect_all_variants_processed(photo)
            expect { photo.source_file.detach }.to_not raise_error
          end
        end
      end
    end
  end

  context '#taken_at=' do
    let(:time) { '2019-01-01 13:00:00' }

    it 'stores as UTC without transforming the timezone' do
      photo.update!(taken_at: time)
      expect(photo.reload.taken_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(time)
    end

    it 'correctly handles a nil value' do
      expect(photo.valid?).to eq(true)
      photo.taken_at = nil
      expect(photo.valid?).to eq(false)
    end

    context 'string contains a time zone' do
      it 'ignores the time zone' do
        [
          '2019-01-01 13:00:00+02:00',
          '2019-01-01 13:00:00-02:00',
          '2019-01-01 13:00:00+0200',
          '2019-01-01 13:00:00-0200'
        ].each do |time|
          photo.update!(taken_at: time)
          expect(photo.taken_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(
            time.first(19)
          )
        end
      end
    end

    context 'an object that implements `strftime()` is provided' do
      it 'stores as UTC without transforming the timezone' do
        time_obj = Time.parse(time)

        photo.update!(taken_at: time_obj)
        expect(photo.reload.taken_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(time)
      end
    end
  end

  def expect_all_variants_processed(photo)
    Photo::SOURCE_FILE_SIZES.each do |_variant, transformations|
      variant = photo.source_file.variant(transformations)
      expect(variant.send(:processed?)).to be_truthy
    end
  end
end
