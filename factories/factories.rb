require 'faker'

FactoryGirl.define do

  factory :event do
    artist { Faker::Name.name }
    venue { Faker::Address.city }
    date { rand(11).months.from_now }
    doors { rand(11).hours.from_now }
    ticket_price { 10.0 + rand(9) }
    trait :visible  do
      state :visible
    end
    trait :with_user do
      users { |a| [a.association(:user)] }
    end
    trait :invalid do
      artist nil
    end
  end

  factory :user do
    email { Faker::Internet.email }
    password "foobar"
    # sequence(:email) { |n| "Jim{n}@creteboom.com" }
    # confirmed_at Time.now #if I wanted to have every user confirmed
    trait :promoter_role  do
      after(:create) {|user| user.add_role(:promoter)}
    end
    trait :confirmed_user do
      after(:build) {|user| user.confirm!}
    end
  end

  factory :profile do
    promoter_name { Faker::Name.name }
    trait :visible_verified do

      state :verified
      visible true
    end
  end

  factory :order do
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    state :dummy
  end

end

