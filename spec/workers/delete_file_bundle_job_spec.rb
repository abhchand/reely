require "rails_helper"

RSpec.describe DeleteFileBundleJob, type: :worker do
  let(:uuid) { SecureRandom.hex }

  let(:download_dir) do
    Rails.configuration.x.default_download_dir.join(uuid)
  end

  before { reset_dir!(download_dir) }

  it "deletes the bundle directory" do
    FileUtils.mkdir_p(download_dir)
    `touch #{download_dir}/some-file.txt`

    expect do
      DeleteFileBundleJob.new.perform(uuid)
    end.to change { download_dir.exist? }.from(true).to(false)
  end

  context "bundle directory does not exist" do
    it "does nothing and completes without error" do
      expect { DeleteFileBundleJob.new.perform(uuid) }.to_not raise_error
    end
  end
end
