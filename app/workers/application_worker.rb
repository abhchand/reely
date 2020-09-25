class ApplicationWorker
  include Sidekiq::Worker

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.error [
                           "Sidekiq Retries Exhausted - #{msg['class']}",
                           "with #{msg['args']}:",
                           msg['error_message'].to_s
                         ].join(' ')
  end
end
