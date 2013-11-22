ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/mock"
require 'turn/autorun'
require 'sidekiq/testing'
require 'vcr'

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
  # fixtures :all
  def self.prepare
  end
  # prepare #run before all tests
  def setup
  end

  def teardown
    Sidekiq::Worker.clear_all
  end
end

class ActionDispatch::IntegrationTest
  require "minitest/rails/capybara"
  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist

  def teardown
    Capybara.current_driver = nil
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

