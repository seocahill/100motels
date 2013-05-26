require 'faker'

FactoryGirl.define do
  factory :event do
    artist { Faker::Name.name }
    date { rand(11).months.from_now }
    doors { rand(11).hours.from_now }
    venue { Faker::Address.city }
    capacity 200
    title { Faker::Lorem.characters(char_count = 29)}
    ticket_price { 10.0 + rand(9) }
    about { Faker::Lorem.paragraphs(2)}
    music "https://soundcloud.com/creteboom/bona-fide"
    video "https://www.youtube.com/watch?v=TY5winxPMvA"
    target 150
    image "https://s3-us-west-2.amazonaws.com/onehundredmotels/247915_156305404435251_2616225_n.jpg"
    trait :hidden  do
      state :guest
    end
    trait :visible do
      state :member
    end
  end
end