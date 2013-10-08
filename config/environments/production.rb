OneHundredMotels::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  config.eager_load = true

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # turbo assets
  config.assets.expire_after 2.weeks

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Set the mailer to localhost
  config.action_mailer.default_url_options = { :host => 'www.100motels.com', :protocol => 'https' }

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "creteboom.com",
    :authentication => "plain",
    :user_name => ENV["GMAIL_USER"],
    :password => ENV["GMAIL_PASSWORD"],
    :enable_starttls_auto => true
  }

end
