class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :dogs, dependent: :destroy

  attr_accessor :agreement

  # validations
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, uniqueness: true, email_format: { message: 'の様式が正しくありません' }
  validates :deactivation, inclusion: { in: [true, false] }
  validates :enable_notification, inclusion: { in: [true, false] }
  validates :agreement, acceptance: true
end
