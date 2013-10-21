require 'faker'

FactoryGirl.define do

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "secret"
    factory :confirmed do
      confirmation_token "a token"
      confirmation_sent_at { Date.today }
    end
  end
end