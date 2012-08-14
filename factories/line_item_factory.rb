# require 'faker'

# FactoryGirl.define do
#   factory :line_item do
#    sequence(:cart_id) { |n| n + 1 }
#    sequence(:event_id) { |n| n + 1 }
#    sequence(:order_id) { |n| n + 1 }
#   end

#   factory :invalid_line_item, parent: :line_item do
#     cart_id nil
#   end
# end