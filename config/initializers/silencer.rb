require 'silencer/logger'

Rails.application.configure do
  config.middleware.insert_before(
    Rails::Rack::Logger,
    Silencer::Logger,
    config.log_tags,
    silence: ["/noisy/action.json"]
  )
end
