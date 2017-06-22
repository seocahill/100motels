# require "codeclimate-test-reporter"
# CodeClimate::TestReporter.start
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

class ActionDispatch::IntegrationTest
  require "minitest/rails/capybara"
  require 'capybara/poltergeist'

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {window_size: [1280, 800], js_errors: true})
  end

  Capybara.register_driver :poltergeist_debug do |app|
    Capybara::Poltergeist::Driver.new(app, :inspector => true)
  end

  Capybara.javascript_driver = :poltergeist

  def teardown
    Capybara.current_driver = Capybara.default_driver
    Capybara.reset_sessions!
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

