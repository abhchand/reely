module GeneralHelpers
  def mailer_queue
    Sidekiq::Extensions::DelayedMailer.jobs.map do |job|
      # rubocop:disable Security/YAMLLoad
      klass,
      method_name,
      args =
        YAML.load(job['args'].first)
      # rubocop:enable Security/YAMLLoad
      method_name = args.shift if method_name == :send

      params = klass.instance_method(method_name).parameters.map { |p| p[1] }

      at = nil
      at = Time.zone.at(job['at']) if job['at']

      {
        klass: klass, method: method_name, args: Hash[params.zip(args)], at: at
      }
    end
  end

  def mailer_names
    mailer_queue.map { |mq| mq[:method] }
  end

  def clear_mailer_queue
    Sidekiq::Extensions::DelayedMailer.clear
  end
end
