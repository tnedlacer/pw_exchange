# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pw_recipient_authentication do
    association :pw_recipient
  end
end
