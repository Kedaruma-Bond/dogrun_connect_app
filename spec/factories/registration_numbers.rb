FactoryBot.define do
  factory :registration_number do
    dogrun_place { 1 }
    registration_number { "MyString" }
    dog { nil }
  end
end
