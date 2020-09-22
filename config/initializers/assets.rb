# rubocop:disable Metrics/LineLength

image_folder = Rails.env.test? ? 'images-test' : 'images'

WEBPACK_PACKS_DIR =
  Rails.root.join('public', Rails.env.test? ? 'packs-test' : 'packs').freeze
WEBPACK_MANIFEST_FILE = WEBPACK_PACKS_DIR.join('manifest.json').freeze
WEBPACK_IMAGE_URL_PREFIX = Pathname.new('/assets').join(image_folder).freeze
WEBPACK_IMAGE_DIR = Rails.root.join('public', 'assets', image_folder)
WEBPACK_DEV_SERVER_HOST = 'http://localhost:3035'.freeze

#
# Development
#

if Rails.env.development?
  Rails.application.config.action_controller.asset_host =
    WEBPACK_DEV_SERVER_HOST
end

#
# inline_svg
#

class CustomSvgAssetLoader
  def self.named(svg_filename)
    File.read(WEBPACK_IMAGE_DIR.join(svg_filename))
  end
end

InlineSvg.configure { |config| config.asset_file = CustomSvgAssetLoader }

# rubocop:enable Metrics/LineLength
