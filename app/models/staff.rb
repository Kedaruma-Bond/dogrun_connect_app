class Staff < ApplicationRecord
  belongs_to :dogrun_place

  # validates
  validates :name, presence: true
  validates :email, presence: true, email_format: { message: I18n.t('defaults.email_message') }
  validates :enable_notification, presence: true

  # enum
  enum enable_notification: { disable: false, enable: true }

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
