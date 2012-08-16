require 'faker'

FactoryGirl.define do

  factory :event do
    artist { Faker::Name.name }
    venue { Faker::Address.city }
    date { Time.now }
    ticket_price { Random.rand(10..25) }
  
    factory :invalid_event do
      artist nil
    end
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@creteboom.com" }
    password "foobar"
    password_confirmation "foobar"
  end

end