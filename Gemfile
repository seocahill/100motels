source 'https://rubygems.org'

gem 'rails', '3.2.7'

group :production do
	gem 'pg'
end

group :developement, :test do
	gem 'rspec-rails'
	gem 'guard-rspec'
	gem 'guard-cucumber'
end

group :test do
	gem 'capybara'
	gem 'rb-inotify'
	gem 'libnotify'
	gem 'spork'
	gem 'guard-spork'
	gem "cucumber-rails", "~> 1.0", require: false
	gem 'database_cleaner'
	gem 'factory_girl'
  gem 'launchy'
  gem 'email_spec'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'dynamic_form'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'devise'