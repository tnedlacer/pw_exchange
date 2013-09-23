# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pw_request do
    password "MyPassword"
    password_confirmation { |u| u.password }
    email "email@example.com"
  end
end
