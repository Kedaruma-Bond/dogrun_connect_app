FactoryBot.define do
  factory :contact do
    name { 'TestUser' }
    sequence(:email) { |n| "test#{n}@example.com" }
    message { 'test' }
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
