# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pw_response do
    association :pw_request
    password "MyPassword"
    remote_ip "192.168.0.1"
    user_agent "Firefox"
  end
end
