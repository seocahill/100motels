require 'factory_girl_rails'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    #require File.expand_path("factories/factories.rb")
    make_users
    make_events_with_users
    #make_something_else
  end
end

def make_users
  FactoryGirl.create(:user, :admin, :confirmed_user)
  15.times do
   FactoryGirl.create(:user)
  end
end

def make_events_with_users
  5.times do
    FactoryGirl.create(:event_with_users)
  end
end
