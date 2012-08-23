require 'faker'

FactoryGirl.define do

  factory :event do
    artist { Faker::Name.name }
    venue { Faker::Address.city }
    date { rand(11).months.from_now }
    doors { rand(11).hours.from_now }
    ticket_price { 10 + rand(9) }

    trait :with_user do
      after(:build) { |event| event.users << FactoryGirl.build(:user) }
    end

    trait :with_admin do
      after(:build) { |event| event.users << FactoryGirl.build(:user, :admin) }
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
      email "seo.cahill@gmail.com"
      password "foobar"
      password_confirmation "foobar"
    end

    factory :confirmed_user do
      after(:build) {|user| user.confirm!}

      trait :confirmed_admin do
        admin true
      end
    end
  end
end