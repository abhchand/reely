class DeleteFileBundleJob < ApplicationWorker
  sidekiq_options retry: 3

  def perform(uuid)
    dir = Rails.configuration.x.default_download_dir.join(uuid)

    FileUtils.rm_rf(dir) if dir.exist?
  end
end
