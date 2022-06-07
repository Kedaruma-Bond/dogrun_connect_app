class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :name,         presence: true, length: { maximum: 50 }
  validates :email,        presence: true, length: { maximum: 255 }, uniqueness: { scope: %i[user_id dogrun_place] }
  validates :dogrun_place, presence: true
  validates :deactivation, presence: true
  validates :enable_notification, presence: true

  enum dogrun_place: { togo_inu_shitsuke_hiroba: 0, dog_with: 1 }
end
