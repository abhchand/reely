require 'rails_helper'

RSpec.describe PhotoPresenter, type: :presenter do
  let(:model) { create(:user) }
  let(:user) { UserPresenter.new(model, view: view_context) }

  describe '#avatar_path' do
    let(:model) { create(:user, with_avatar: true) }

    it 'returns the avatar url based on the size' do
      # No size specified
      expect(user.avatar_path).to eq(avatar_path_for(user))

      # Size specified
      expect(user.avatar_path(size: :thumb)).to eq(
        avatar_path_for(user, size: :thumb)
      )
    end

    it 'raises an error when size is invalid' do
      expect { user.avatar_path(size: :foo) }.to raise_error(
        /Unknown avatar size/
      )
    end

    context 'no avatar attached' do
      let(:model) { create(:user) }

      it 'returns the default blank avatar based on the size' do
        # No size specified
        expect(user.avatar_path).to eq(image_path('blank-avatar-medium.jpg'))

        # Size specified
        expect(user.avatar_path(size: :thumb)).to eq(
          image_path('blank-avatar-thumb.jpg')
        )
      end
    end
  end

  def avatar_path_for(user, size: nil)
    transformations = User::AVATAR_SIZES[size] || {}
    variant = user.avatar.variant(transformations)

    rails_representation_url(
      variant,
      disposition: 'attachment', only_path: true
    )
  end
end
