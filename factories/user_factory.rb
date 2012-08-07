FactoryGirl.define do
  factory :user do
   sequence(:email) { |n| "user#{n}@creteboom.com" }
   password "foobar"
   password_confirmation "foobar"
  end
end