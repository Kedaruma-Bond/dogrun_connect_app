class Contact < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, email_format: { message: I18n.t('defaults.email_message') }
  validates :message, presence: true, length: { maximum: 1000 }
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
