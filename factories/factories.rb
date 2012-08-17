require 'faker'

FactoryGirl.define do

  factory :event do
    artist { Faker::Name.name }
    venue { Faker::Address.city }
    date { Date.new(2012, 3, 6) }
    ticket_price { Random.rand(10..25) }

    trait :with_user do
      after(:build) { |event| event.users << FactoryGirl.build(:user) }
    end

    trait :invalid do
      artist nil
    end
  end

  factory :user do
    # event
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
  end


end