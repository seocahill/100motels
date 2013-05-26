require 'faker'

FactoryGirl.define do

  factory :member_user, class: "User" do
    association :profile, factory: :member_profile
    # auth_token { SecureRandom.urlsafe_base64 }
    # profile_type "member_profile"
  end

  factory :guest_user, class: "User" do
    association :profile, factory: :guest_profile
    # auth_token { SecureRandom.urlsafe_base64 }
    # profile_type "guest_profile"
  end

  factory :member_profile do
    name "Foo Bar"
    email "foo@bar.com"
    password "secret"
    # factory :confirmed do
      confirmation_token { SecureRandom.urlsafe_base64 }
      confirmation_sent_at { Date.today }
    # end
  end

  factory :guest_profile do
  end
end