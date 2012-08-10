require 'faker'

FactoryGirl.define do
  factory :event do
   # week_num = (Random.rand(10) +1)
   # day_num = (1+Random.rand(30))
   # future_date = week_num.weeks.from_now
   # event_date = Time.local(future_date.year, future_date.month, day_num)
	 artist { Faker::Name.name }
   venue { Faker::Address.city }
   date { Time.now }
   ticket_price { Random.rand(10..25) }
  end
end