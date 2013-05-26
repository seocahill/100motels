require 'faker'

FactoryGirl.define do
  factory :event do
    artist { Faker::Name.name }
    date { rand(11).months.from_now }
    doors { rand(11).hours.from_now }
    venue { Faker::Address.city }
    capacity 200
    title "The Three Ring Circus"
    ticket_price { 10.0 + rand(9) }
    about { Faker::Lorem.paragraphs(3)}
    target 150
    image "https://s3-us-west-2.amazonaws.com/onehundredmotels/247915_156305404435251_2616225_n.jpg"
    association :location
    trait :visible do
      state :member
      visible true
    end
  end

  factory :location do
    address { Faker::Address.street_address }
  end
end