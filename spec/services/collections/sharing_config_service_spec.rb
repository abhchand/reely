require 'rails_helper'

RSpec.describe Collections::SharingConfigService, type: :service do
  let(:collection) { create(:collection) }
  let(:service) { Collections::SharingConfigService.new(collection) }

  describe '#as_json' do
    it 'returns the configuration Hash' do
      expect(service.as_json).to eq(
        via_link: {
          enabled: false,
          url: collections_sharing_display_url(id: collection.share_id)
        }
      )
    end

    context 'link sharing is enabled' do
      before do
        collection.sharing_config['link_sharing_enabled'] = true
        collection.save!
      end

      it 'returns the configuration Hash' do
        expect(service.as_json).to eq(
          via_link: {
            enabled: true,
            url: collections_sharing_display_url(id: collection.share_id)
          }
        )
      end
    end
  end

  describe '#update' do
    it 'handles symbole keys' do
      expect(collection.sharing_config['link_sharing_enabled']).to be_nil

      service.update(link_sharing_enabled: true)
      expect(collection).to be_valid
      expect(collection.sharing_config['link_sharing_enabled']).to eq(true)
    end

    it 'allows toggling the `link_sharing_enabled` config' do
      expect(collection.sharing_config['link_sharing_enabled']).to be_nil

      service.update('link_sharing_enabled' => true)
      expect(collection).to be_valid
      expect(collection.sharing_config['link_sharing_enabled']).to eq(true)

      service.update('link_sharing_enabled' => false)
      expect(collection).to be_valid
      expect(collection.sharing_config['link_sharing_enabled']).to eq(false)
    end
  end
end
