# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket do
    number "MyString"
    admitted "2013-10-30 16:51:25"
    order nil
  end
end
