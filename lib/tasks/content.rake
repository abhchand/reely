namespace :reely do
  namespace :content do
    desc 'Import content into Reely'
    task import: :environment do
      ContentImportQueueingJob.perform_async
    end
  end
end
