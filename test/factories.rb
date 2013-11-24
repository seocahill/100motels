FactoryGirl.define do
  factory :user do
    name { Faker::Name.first_name}
    email { "#{name}@example.com" }
    password "secret"
    guest false
    state "normal"
    after :build, &:generate_token
    trait :stripe_connect do
      api_key "sk_test_kQGNcavkvqWP144unEJ0wnbM"
      stripe_uid "acct_1phxjZEuOipGrP93mEuq"
    end

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
    trait :live_event do
      association :user, factory: [:user, :stripe_connect]
      visible true
    end
  end

  factory :order do
    event
    name { Faker::Name.first_name }
    email { "#{name}@example.com" }
    quantity 5
    ticket_price 10.0
    total 52.33
    stripe_customer_token "cus_2uZqybEghSRtJx"
    after :create, &:add_tickets_to_order
    trait :charged do
      stripe_charge_id "ch_2yLMIbE3EBiMSo"
      stripe_event :charged
    end
    trait :declined do
      stripe_customer_token "cus_2uox3BpZoFOnyN"
    end
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

  factory :message do
    message "Here's an update about your event"
    trait :defer do
      date Date.parse("31 December 2014")
    end
  end
end