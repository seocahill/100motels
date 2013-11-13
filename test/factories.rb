FactoryGirl.define do
  factory :user do
    name "John"
    email  "Doe"
    password "secret"
    guest false
  end
end