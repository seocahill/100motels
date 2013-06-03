ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'factory_girl'
require 'factory_girl_rails'
require 'capybara/poltergeist'
require 'sidekiq/testing/inline'
Capybara.javascript_driver = :poltergeist

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}


RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include Capybara::DSL
  config.include FactoryGirl::Syntax::Methods
  config.include BestInPlace::TestHelpers
  config.include LoginMacros
  config.include MailerMacros
  config.before(:each) { reset_email }
end

