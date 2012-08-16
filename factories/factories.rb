require 'faker'

FactoryGirl.define do
  
  factory :event do
   artist { Faker::Name.name }
   venue { Faker::Address.city }
   date { Time.now }
   ticket_price { Random.rand(10..25) }
  end

  factory :invalid_event, parent: :event do
    artist nil
    ticket_price nil 
  end

  factory :user do
   sequence(:email) { |n| "user#{n}@creteboom.com" }
   password "foobar"
   password_confirmation "foobar"
  end

end