class User < ApplicationRecord
  authenticates_with_sorcery!
  # moduleを引き継ぎたい -> include。 DBに保存しないnumber_of_dogsのvalidationを効かすために必要
  has_many :dogs, dependent: :destroy

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
end
