class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :dogs, dependent: :destroy

  attr_accessor :agreement

  # validations
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, email_format: { message: 'の様式が正しくありません' }
  validates :deactivation, inclusion: { in: [true, false] }
  validates :enable_notification, inclusion: { in: [true, false] }
  validates :agreement, acceptance: true
end

# == Schema Information
#
# Table name: users
#
#  id                           :bigint           not null, primary key
#  crypted_password             :string
#  deactivation                 :boolean          default(FALSE), not null
#  email                        :string           not null
#  enable_notification          :boolean          default(FALSE), not null
#  name                         :string           not null
#  remember_me_token            :string
#  remember_me_token_expires_at :datetime
#  salt                         :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_users_on_email              (email) UNIQUE
#  index_users_on_remember_me_token  (remember_me_token)
#
