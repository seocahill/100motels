FactoryGirl.define do
  factory :user do
    name { Faker::Name.first_name}
    email { "#{name}@example.com" }
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
    name  { Faker::Lorem.characters(49) }
    location { Faker::Address.city }
    date { 3.months.from_now }
    about { Faker::Lorem.paragraph(3) }
    target 100
    ticket_price 10.0
  end

  factory :order do
    event
    name { Faker::Name.first_name }
    email { "#{name}@example.com" }
    quantity { rand(5) }
    ticket_price { event.ticket_price }
    total { (quantity * ticket_price) }
    stripe_customer_token { Faker::Lorem.characters(32) }
    after :create, &:add_tickets_to_order
    trait :in_progress do
      name nil
      email { Faker::Internet.email }
      stripe_customer_token nil
      last4 nil
      ticket_price nil
      total nil
    end
  end

  factory :ticket do
    before :create, &:generate_ticket_number
  end
end