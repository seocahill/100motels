source 'https://rubygems.org'

gem 'rails', '3.2.8'

group :production do
	gem 'pg'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'thin'
end

group :developement, :test do
	gem 'rspec-rails'
	gem 'guard-rspec'
	gem 'guard-cucumber'
  gem 'factory_girl_rails'
  gem 'guard-livereload'
  gem 'rack-livereload'
  gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
end

group :test do
  gem 'faker'
	gem 'capybara'
	gem 'rb-inotify'
	gem 'libnotify'
	gem 'spork'
	gem 'guard-spork'
	gem "cucumber-rails", "~> 1.0", require: false
	gem 'database_cleaner'
  gem 'launchy'
  gem 'email_spec'
  gem "shoulda-matchers"
  gem 'capybara-page-object'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'dynamic_form'
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '~> 2.1.0.0'
end

gem 'jquery-rails'
gem 'devise'
gem 'simple_form'
gem 'stripe'
gem 'heroku'
gem 'doorkeeper'
gem 'roadie'
gem 'rabl'
gem 'omniauth-stripe-platform'
gem 'foreman'