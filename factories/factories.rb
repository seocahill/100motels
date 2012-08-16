require 'faker'

FactoryGirl.define do

  factory :event do
    artist { Faker::Name.name }
    venue { Faker::Address.city }
    date { Time.now }
    ticket_price { Random.rand(10..25) }
    #Eafter(:create) { |event| event.users << FactoryGirl.create(:user) }

    trait :invalid do
      artist nil
    end
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@creteboom.com" }
    password "foobar"
    password_confirmation "foobar"
  
    trait :admin do 
      admin true
    end

    factory :confirmed_user do
      after(:build) {|user| user.confirm!}

      trait :confirmed_admin do
        admin true
      end
    end

    factory :events_users do
      event
      user
    end
  end


end