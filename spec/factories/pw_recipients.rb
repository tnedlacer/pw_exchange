# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pw_recipient do
    association :pw_sender
    email "email@example.com"
  end
end
