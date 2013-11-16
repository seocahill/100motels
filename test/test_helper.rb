ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "minitest/mock"
require 'turn/autorun'
require 'sidekiq/testing'
Sidekiq::Testing.fake!
Sidekiq::Worker.clear_all
OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:stripe_connect,
 {'uid' => '12345', 'credentials' => {'token' => 'secret_access'}})
class ActiveSupport::TestCase
  def self.prepare
  end
  # prepare
  def setup
  end

  def teardown
    Sidekiq::Worker.clear_all
  end
end
