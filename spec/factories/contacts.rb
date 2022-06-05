FactoryBot.define do
  factory :contact do
    name { 'TestUser' }
    sequence(:email) { |n| "test#{n}@example.com" }
    message { 'test' }
  end
end
