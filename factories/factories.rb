require 'faker'

FactoryGirl.define do

  factory :event do
    artist { Faker::Name.name }
    venue { Faker::Address.city }
    date { rand(11).months.from_now }
    doors { rand(11).hours.from_now }
    ticket_price { 10.0 + rand(9) }

    trait :invalid do
      artist nil
    end

    factory :event_with_users do
      ignore do
        users_count 1
      end
      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:user, :confirmed_user, evaluator.users_count, event: event)
      end
    end
  end

  factory :user do
    # name = Faker::Name.name
    sequence(:email) { |n| "Jim{n}@creteboom.com" }
    password "foobar"
    password_confirmation "foobar"
    event

    trait :admin do
      admin true
      email "seo.cahill@gmail.com"
      password "foobar"
      password_confirmation "foobar"
    end

    trait :confirmed_user do
      after(:build) {|user| user.confirm!}
    end
  end
end