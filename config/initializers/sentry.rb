# frozen_string_literal: true

# Raven.configure do |config|
#   config.dsn                 = "#{ENV['SENTRY_DSN']}"
#   config.sanitize_fields     = Rails.application.config.filter_parameters.map(&:to_s)
#   config.environments        = ENV.fetch('SENTRY_DEPLOY_ENVIRONMENTS', %w[development staging production])
#   config.current_environment = ENV.fetch('SENTRY_DEPLOY_ENVIRONMENT', 'development')
#   config.release = File.read('VERSION').squish || '' rescue ''
# end
Raven = Sentry

Raven.init do |config|
  config.dsn                  = "#{ENV['SENTRY_DSN']}"
  config.enabled_environments = ENV.fetch('SENTRY_DEPLOY_ENVIRONMENTS', %w[development staging production])
  config.environment          = ENV.fetch('SENTRY_DEPLOY_ENVIRONMENT', 'development')

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  # config.traces_sample_rate = 0.5
  # or
  if ActiveModel::Type::Boolean.new.cast(ENV.fetch('SENTRY_ENABLE_APM', false))
    config.traces_sampler = lambda do |context|
      transaction = context[:transaction_context]

      # if the transaction is important, set a higher rate
      unless transaction[:name].match?("health")
        0.5
      end
    end
  end

  filter             = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  config.before_send = lambda do |event, hint|
    # note1: if you have config.async configured, the event here will be a Hash instead of an Event object
    # note2: the code below is just an example, you should adjust the logic based on your needs
    event.request.data = filter.filter(event.request.data) if event.request
    event
  end
end
