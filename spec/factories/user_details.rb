FactoryBot.define do
  factory :user_detail do
    zip_code { Faker::Address.zip_code }
    address_1 { Faker::Address.state }
    address_2 { Faker::Address.city }
    phone_number { Faker::PhoneNumber.phone_number }
    association :user
  end
end
# == Schema Information
#
# Table name: user_details
#
#  id           :bigint           not null, primary key
#  address_1    :string(50)       not null
#  address_2    :string(50)
#  phone_number :string(13)       not null
#  zip_code     :string(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_user_details_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
