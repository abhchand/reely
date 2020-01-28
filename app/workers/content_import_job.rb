class ContentImportJob < ApplicationWorker
  def perform(owner_id, filepath)
    @filepath = Pathname.new(filepath)
    @owner = User.find(owner_id)

    @service = Photos::ImportService.call(owner: @owner, filepath: @filepath)

    return if @service.failure?

    remove_file
    remove_dir
  end

  private

  def log_tag
    [self.class.name, @job_id].map { |t| "[#{t}]" }.join
  end

  def remove_file
    Rails.logger.info("#{log_tag} Removing file #{@filepath}")
    FileUtils.rm(@filepath)
  end

  def remove_dir
    dir = @filepath.dirname
    return unless dir.empty?

    Rails.logger.info("#{log_tag} Removing dir #{dir}")
    FileUtils.rm_rf(dir)
  end
end
