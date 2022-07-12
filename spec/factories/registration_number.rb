FactoryBot.define do
  factory :registration_number do
    dogrun_place { 0 }
    registration_number { Faker::Number.between(from: 1, to: 2000) }
    association :dog
  end
end
