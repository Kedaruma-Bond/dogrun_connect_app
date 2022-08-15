class Dog < ApplicationRecord
  belongs_to :user
  has_many :registration_numbers, dependent: :destroy
  has_many :entries, dependent: :nullify
  mount_uploader :thumbnail_photo, ThumbnailUploader

  # validates
  validates :name, presence: true, length: { maximum: 50 }
  validates :castration, presence: true
  validates :public, presence: true
  validates :breed, allow_nil: true, length: { maximum: 50 }
  validates :weight, allow_nil: true, numericality: { greater_than: 0 }
  validates :owner_comment, allow_nil: true, length: { maximum: 400 }

  # enum
  enum castration: { castrated: true, non_castrated: false }
  enum public: { public_view: true, non_public: false }
  enum sex: { male: 0, female: 1 }

end

# == Schema Information
#
# Table name: dogs
#
#  id              :bigint           not null, primary key
#  birthday        :date
#  breed           :string           default("")
#  castration      :boolean          not null
#  name            :string           not null
#  owner_comment   :text             default("")
#  public          :boolean          not null
#  sex             :integer
#  thumbnail_photo :string
#  weight          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_dogs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
