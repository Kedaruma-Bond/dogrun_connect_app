FactoryBot.define do
  factory :article do
    content { Faker::Lorem.sentences(number: 3) }
    association :post
  end
end
