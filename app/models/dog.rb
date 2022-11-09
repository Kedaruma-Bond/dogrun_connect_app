class Dog < ApplicationRecord
  belongs_to :user
  has_many :registration_numbers, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :friend_dogs, dependent: :destroy
  mount_uploader :thumbnail_photo, ThumbnailUploader
  has_one_attached :as_thumbnail_photo

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

  #   scope
  scope :dogrun_place_id, -> (id) { joins(:registration_numbers).where(registration_numbers: { dogrun_place_id: id }).includes(:registration_numbers, :user).order(id: :desc)}
  scope :dogrun_place_id_for_friend_dog, -> (id) { joins(:entries, :registration_numbers).where(entries: { exit_at: nil }).where(registration_numbers: { dogrun_place_id: 2 }).includes(:entries, :registration_numbers, :user)}

  after_commit do
    update_active_storage if previous_changes.keys.include?('thunbnail_photo')
  end

  def update_active_storage
    self.as_thumbnail_photo.purge if self.as_thumbnail_photo.attached?
    sync_thumbnail_photo if self.thumbnail_photo.present?
  rescue StandardError -> error
    Log.error(error)
  end

  def sync_thumbnail_photo
    photo = self.thumbnail_photo
    photo.cache_stored_file!
    file = photo.sanitized_file.file
    content_type = photo.content_type
    self.as_thumbnail_photo.attach(io: file, content_type: content_type, filename: self.attributes['thumbnail_photo'])
  end
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
