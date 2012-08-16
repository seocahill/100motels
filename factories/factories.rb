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
  
    factory :admin do 
      admin true
    end

    factory :confirmed_user do
      after(:build) {|user| user.confirm!}

      factory :confirmed_admin do
        admin true
      end
    end
  end


end