class Dog < ApplicationRecord
  belongs_to :user
  has_many :registration_numbers, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :castration, presence: true
  validates :public, presence: true
  validates :breed, length: { maximum: 50 }
  validates :sex, allow_nil: true, numericality: { in: 0..1 }
  validates :birthday, allow_nil: true
  validates :weight, allow_nil: true, numericality: { greater_than: 0 }
  validates :owner_comment, length: { maximum: 400 }

  enum sex: { male: 0, female: 1 }
end

# == Schema Information
#
# Table name: dogs
#
#  id            :bigint           not null, primary key
#  birthday      :date
#  breed         :string           default("")
#  castration    :boolean          default(FALSE), not null
#  name          :string           not null
#  owner_comment :text             default("")
#  public        :boolean          default(FALSE), not null
#  sex           :integer
#  weight        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_dogs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
