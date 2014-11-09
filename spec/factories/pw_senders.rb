# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pw_sender do
    password "MyPassword"
    email_0 "email@example.com"
  end
end
