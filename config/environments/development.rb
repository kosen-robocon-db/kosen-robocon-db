Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Set the same callback URL as the callback URL set in Twitter Apps.
  # Devise.setup do |config|
  #   config.omniauth :twitter, 'hQtjCJsH53r70LHX9YA8FYa4u', 'fay4u8KvGPQwwl5AbouLh26byEQMLSRw54jVA87iFrQv0wklOL', :display => 'popup', callback_url: "http://localhost:3000/users/auth/twitter/callback"
  # end
  Devise.setup do |config|
    config.omniauth :twitter,
      Rails.application.credentials.config[:development][:twitter_api_key],
      Rails.application.credentials.config[:development][:twitter_api_secret],
      :display => 'popup',
      callback_url: "http://localhost:3000/users/auth/twitter/callback"
  end
  puts ">>>> twitter_api_key(credentials):#{Rails.application.credentials.config[:development][:twitter_api_key]}"
  puts ">>>> twitter_api_secret(credentials):#{Rails.application.credentials.config[:development][:twitter_api_secret]}"
  puts ">>>> Devise.omniauth_configs:#{Devise.omniauth_configs}"
  puts ">>>> credentials.secret_key_base:#{Rails.application.credentials.secret_key_base}"
  puts ">>>> secrets.secret_key_base:#{Rails.application.secrets.secret_key_base}"
  puts ">>>> config.secret_key_base:#{Rails.application.config.secret_key_base}"
  puts ">>>> secret_key_base:#{Rails.application.secret_key_base}"
  

  # Added below the configuration in order not to cause error like this:
  # Cannot render console from 10.0.2.2! Allowed networks: 127.0.0.1, ::1, 127.0.0.0/127.255.255.255
  config.web_console.whitelisted_ips = '0.0.0.0/0'

end
