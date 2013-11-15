FactoryGirl.define do
  factory :user do
    name "John"
    sequence(:email) { |n| "name#{n}@example.com" }
    password "secret"
    guest false
    state "normal"
    after :build, &:generate_token

    factory :guest do
      name nil
      email nil
      password nil
      guest true
    end
  end

  factory :event do
    user
    name  { Faker::Lorem.sentence(3) }
    location "Dublin, Ireland"
    date { 3.months.from_now }
    about { Faker::Lorem.paragraph(3) }
    target 100
    ticket_price 10.0
  end
end