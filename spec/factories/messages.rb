require 'faker'

FactoryGirl.define do

  factory :message do
    subject "Important!"
    organizer_email "seo@example.com"
    email { Faker::Internet.email }
    content "This is very serious"
    event_id 1
  end
end