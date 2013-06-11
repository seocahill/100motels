require 'faker'

FactoryGirl.define do
  factory :order do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    quantity { rand(4) }
    last4 4242
    stripe_event :pending
  # end 
end
end