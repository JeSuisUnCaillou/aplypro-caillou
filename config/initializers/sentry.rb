# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV.fetch("APLYPRO_SENTRY_DSN", nil)
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end

  config.include_local_variables = true

  # this is provided by Scalingo
  config.release = ENV.fetch("CONTAINER_VERSION", nil)

  config.environment = ENV.fetch("APLYPRO_ENV")
end
