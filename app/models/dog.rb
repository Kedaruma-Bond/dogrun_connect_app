class Dog < ApplicationRecord
  belongs_to :user
  has_many :registration_numbers, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :encount_dogs, dependent: :destroy
  has_many :encounts, dependent: :destroy
  has_one_attached :thumbnail

  # validates
  validates :name, presence: true, length: { maximum: 50 }
  validates :castration, presence: true
  validates :public, presence: true
  validates :breed, allow_nil: true, length: { maximum: 50 }
  validates :weight, allow_nil: true, numericality: { greater_than: 0 }
  validates :owner_comment, allow_nil: true, length: { maximum: 400 }
  validates :thumbnail, size: { less_than: 10.megabytes }

  # enum
  enum castration: { castrated: true, non_castrated: false }
  enum public: { public_view: true, non_public: false }
  enum sex: { male: 0, female: 1 }

  #   scope
  scope :dogrun_place_id, -> (id) { joins(:registration_numbers).where(registration_numbers: { dogrun_place_id: id }).includes(:registration_numbers, :user).order(id: :desc)}
  scope :dogrun_place_id_for_encount_dog, -> (id) { joins(:entries, :registration_numbers).where(entries: { exit_at: nil }).where(registration_numbers: { dogrun_place_id: 2 }).includes(:entries, :registration_numbers, :user)}

end

# == Schema Information
#
# Table name: dogs
#
#  id            :bigint           not null, primary key
#  birthday      :date
#  breed         :string           default("")
#  castration    :boolean          not null
#  name          :string           not null
#  owner_comment :text             default("")
#  public        :boolean          not null
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
