require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/mock"
require 'sidekiq/testing'
require 'vcr'
require "minitest/reporters"

Minitest::Reporters.use!
Rails.logger.level = 4

Sidekiq::Testing.fake!

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:stripe_connect,
 {'uid' => '12345', 'credentials' => {'token' => 'secret_access'}})

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = Rails.root.join("test", "fixtures", "vcr_cassettes" )
  c.hook_into :webmock
end

class ActiveSupport::TestCase
  def teardown
    Sidekiq::Worker.clear_all
  end
end

require 'capybara/rails'
require 'capybara/minitest'

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions
  
  Capybara.register_driver "selenium_standalone_firefox".to_sym do |app|
    Capybara::Selenium::Driver.new(
      app, browser: :remote, url: "http://selenium:4444/wd/hub", desired_capabilities: :firefox
    )
  end
  Capybara.javascript_driver = :selenium_standalone_firefox

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.app_host = nil
    Capybara.use_default_driver
  end

  def use_js_driver
    container_address = `hostname`.strip
    Capybara.server_port = "3000"
    Capybara.server_host = container_address
    Capybara.app_host = "http://#{container_address}:3000"
    Capybara.current_driver = Capybara.javascript_driver
  end
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil
  def self.connection
    @@shared_connection || retrieve_connection
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

module SharedBehaviour
  def sign_in(user)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  def signed_in
    event = FactoryGirl.create(:event)
    sign_in(event.user)
  end

  def event_admin
    live_event = FactoryGirl.create(:event, :live_event)
    sign_in(live_event.user)
  end
end

