require 'faker'

FactoryGirl.define do
  factory :event do
    artist { Faker::Name.name }
    date { rand(11).months.from_now }
    doors { rand(11).hours.from_now }
    venue { Faker::Address.city }
    title "A Title for your show"
    about { Faker::Lorem.paragraphs(3)}
    target 100
    capacity 200
    ticket_price 15.0
    association :location
    after(:build) do |event|
      event.stub(:forbid_publish).and_return true
    end
    trait :visible do
      state :member
      visible true
    end
  end

  factory :location do
    address { Faker::Address.street_address }
  end
end