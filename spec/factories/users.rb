require 'faker'

FactoryGirl.define do

  factory :member_user, class: "User" do
    association :profile, factory: :member_profile
  end

  factory :guest_user, class: "User" do
    association :profile, factory: :guest_profile
  end

  factory :member_profile do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "secret"
    # factory :confirmed do
      confirmation_token "a token"
      confirmation_sent_at { Date.today }
    # end
  end

  factory :guest_profile do
  end
end