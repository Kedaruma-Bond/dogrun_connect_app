class UserDetail < ApplicationRecord
  belongs_to :users, optional: true

  # validations
  VALID_POSTAL_CODE_REGEX = /\A\d{3}[-]?\d{4}\z/ 
  validates :zip_code, presence: true, format: { with: VALID_POSTAL_CODE_REGEX }
  validates :address_1, presence: true, length: { maximum: 50 }
  validates :address_2, length: { maximum: 50 }
  VALID_PHONE_NUMBER_REGEX = /\A0(\d{1}[-(]?\d{4}|\d{2}[-(]?\d{3}|\d{3}[-(]?\d{2}|\d{4}[-(]?\d{1})[-)]?\d{4}\z|\A0[5789]0[-]?\d{4}[-]?\d{4}\z/
  validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }

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
