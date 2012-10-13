require 'faker'

FactoryGirl.define do

  factory :event do
    artist { Faker::Name.name }
    venue { Faker::Address.city }
    date { rand(11).months.from_now }
    doors { rand(11).hours.from_now }
    ticket_price { 10.0 + rand(9) }

    trait :with_user do
      users { |a| [a.association(:user)] }
    end

    trait :invalid do
      artist nil
    end
  end

  factory :user do
    email { Faker::Internet.email }
    # sequence(:email) { |n| "Jim{n}@creteboom.com" }
    password "foobar"
    password_confirmation "foobar"


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

  factory :order do
    name  { Faker::Name.name }
    email { Faker::Internet.email }

  end


end

