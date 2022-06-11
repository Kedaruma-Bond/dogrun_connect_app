class Dog < ApplicationRecord
  belongs_to :user
  has_many :registration_numbers

  validates :dog_name, presence: true, length: { maximum: 50 }
  validates :breed, length: { maximum: 50 }
  validates :owner_comment, length: { maximum: 400 }
  # validate :pretend_future

  # birthdayが日付形式になってない？からエラーが出てる模様
  # purseメソッドで変換してやる？
  # def pretend_future
  #   errors.add(:birthday, '誕生日のエラーです') if birthday > Time.zone.today
  # end
end
