require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module OneHundredMotels
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    # config.active_record.schema_format = :sql
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false
    config.generators do |g|
      g.test_framework :mini_test, fixture: false
    end
    config.filepicker_rails.api_key = ENV["FILEPICKER_API_KEY"]
    config.i18n.enforce_available_locales = false
    config.active_support.test_order = :sorted
  end
end
