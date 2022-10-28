FactoryBot.define do
  factory :staff do
    name { Faker::Name.name }
    sequence(:email) { |n| "staff_#{n}@example.com" }
    association :dogrun_place

    trait :disable do
      enable_notification { 'disable' }
    end

    trait :enable do
      enable_notification { 'enable' }
    end
  end
end

# == Schema Information
#
# Table name: staffs
#
#  id                  :bigint           not null, primary key
#  email               :string           not null
#  enable_notification :boolean          default("disable"), not null
#  name                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  dogrun_place_id     :bigint           not null
#
# Indexes
#
#  index_staffs_on_dogrun_place_id  (dogrun_place_id)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#
