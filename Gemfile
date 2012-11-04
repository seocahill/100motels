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
  gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
  gem 'foreman'
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
  gem 'bootstrap-sass'
  gem 'turbo-sprockets-rails3'
end

gem 'jquery-rails'
gem 'mercury-rails'
gem 'devise'
gem 'simple_form'
gem 'stripe'
gem 'doorkeeper'
gem 'roadie'
gem 'rabl'
gem 'omniauth-stripe-connect'
gem 'attr_encrypted'
gem 'cancan'
gem 'rolify'
gem 'bootstrap-will_paginate'
gem 'prawn'
gem "auto_html"
gem 'filepicker-rails'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
gem 'geocoder'
gem 'texticle', require: 'texticle/rails'
gem 'enum_accessor'
gem 'google-qr'
gem 'has_scope'
gem 'active_attr'
gem 'activerecord-postgres-hstore'