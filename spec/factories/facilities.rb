FactoryBot.define do
  factory :facility do
    sequence(:name) { |n| "Facility_#{n}" }
  end
end
# == Schema Information
#
# Table name: facilities
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
