ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'factory_girl'
require 'factory_girl_rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

FakeWeb.allow_net_connect = false

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
end

