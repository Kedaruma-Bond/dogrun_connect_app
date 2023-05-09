class Dog < ApplicationRecord
  belongs_to :user
  has_many :registration_numbers, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_one :pre_entry, dependent: :destroy
  has_many :encount_dogs, dependent: :destroy
  has_many :encounts, dependent: :destroy
  has_one_attached :thumbnail
  has_one_attached :mixed_vaccination_certificate
  has_one_attached :rabies_vaccination_certificate
  has_one_attached :license_plate
  include JpPrefecture
  jp_prefecture :registration_prefecture_code, method_name: :pref

  # validates
  validates :name, presence: true, length: { maximum: 50 }
  validates :castration, presence: true
  validates :public, presence: true
  validates :breed, allow_nil: true, length: { maximum: 50 }
  validates :weight, allow_nil: true, numericality: { greater_than: 0 }
  validates :owner_comment, allow_nil: true, length: { maximum: 400 }
  validates :thumbnail, size: { less_than: 10.megabytes }, content_type: [:png, :jpg, :jpeg, :heif]
  validates :mixed_vaccination_certificate, size: { less_than: 10.megabytes }, content_type: [:png, :jpg, :jpeg, :heif]
  validates :rabies_vaccination_certificate, size: { less_than: 10.megabytes }, content_type: [:png, :jpg, :jpeg, :heif]
  validates :license_plate, size: { less_than: 10.megabytes }, content_type: [:png, :jpg, :jpeg, :heif]
  validates :registration_municipality, length: { maximum: 30 }
  validates :municipal_registration_number, length: { maximum: 10 }

  # enum
  enum castration: { castrated: true, non_castrated: false }
  enum public: { public_view: true, non_public: false }
  enum filming_approval: { filming_approval: true, filming_not_approval: false }
  enum sns_post_approval: { sns_post_approval: true, sns_post_not_approval: false }
  enum sex: { male: 0, female: 1 }

  # delegate
  delegate :user_detail, to: :user

  # scope
  scope :dogrun_place_id, -> (id) { includes(:registration_numbers, :user).where(registration_numbers: { dogrun_place_id: id }).order(id: :desc)}
  # scope :dogrun_place_id_for_encount_dog, -> (id) { includes(:entries, :registration_numbers, :user).where(entries: { exit_at: nil }).where(registration_numbers: { dogrun_place_id: id }) }

  # ransack authorization
  def self.ransackable_attributes(auth_object = nil)
    ["birthday", "breed", "castration", "created_at", "date_of_mixed_vaccination", "date_of_rabies_vaccination", "filming_approval", "id", "municipal_registration_number", "name", "public", "registration_municipality", "registration_prefecture_code", "sex", "sns_post_approval", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["encount_dogs", "encounts", "entries", "license_plate_attachment", "license_plate_blob", "mixed_vaccination_certificate_attachment", "mixed_vaccination_certificate_blob", "pre_entry", "rabies_vaccination_certificate_attachment", "rabies_vaccination_certificate_blob", "registration_numbers", "thumbnail_attachment", "thumbnail_blob", "user"]
  end

end

# == Schema Information
#
# Table name: dogs
#
#  id                            :bigint           not null, primary key
#  birthday                      :date
#  breed                         :string           default("")
#  castration                    :boolean          not null
#  date_of_mixed_vaccination     :date
#  date_of_rabies_vaccination    :date
#  filming_approval              :boolean
#  municipal_registration_number :integer
#  name                          :string           not null
#  owner_comment                 :text             default("")
#  public                        :boolean          not null
#  registration_municipality     :string           default("")
#  registration_prefecture_code  :integer
#  sex                           :integer
#  sns_post_approval             :boolean
#  weight                        :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :bigint           not null
#
# Indexes
#
#  index_dogs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
