require 'factory_girl_rails'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    #require File.expand_path("factories/factories.rb")
    make_users
    make_events
    make_orders

  end
end

def make_users
  FactoryGirl.create(:user, :admin, :confirmed_user)
  15.times do
   FactoryGirl.create(:user, :confirmed_user)
  end
end

def make_events
  5.times do
    FactoryGirl.create(:event)
  end
end

def make_orders
  150.times do
    FactoryGirl.create(:order)
  end
end