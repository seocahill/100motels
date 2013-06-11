require 'faker'

FactoryGirl.define do
  factory :order do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    quantity { rand(4) }
    last4 4242
    stripe_event :pending
    trait :paid do
      stripe_event :paid
    end
    trait :cancelled do
      stripe_event :cancelled
    end
    trait :refunded do
      stripe_event :refunded
    end
end
end