FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "Testuser_#{n}" }
    sequence(:email) { |n| "test_#{n}@example.com" }
    message { Faker::Lorem.question(word_count: 7) }
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  message    :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
