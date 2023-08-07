class DogrunPlace < ApplicationRecord
  has_many :registration_numbers
  has_many :posts, dependent: :destroy
  has_many :staffs, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :encount_dogs, dependent: :destroy
  has_many :encounts, dependent: :destroy
  has_many :dogrun_place_facility_relations, dependent: :destroy
  has_many :facilities, through: :dogrun_place_facility_relations, dependent: :destroy
  has_one :sns_account, dependent: :destroy
  has_one_attached :logo
  has_one_attached :registration_card
  include JpPrefecture
  jp_prefecture :prefecture_code, method_name: :pref

  # validation
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
  validates :logo, size: { less_than: 10.megabytes }, content_type: [:png, :jpg, :jpeg, :heif]
  validates :registration_card, size: { less_than: 10.megabytes }, content_type: [:png, :jpg, :jpeg, :heif]

  # enum
  enum force_closed: { force_closing: true, releasing: false }   

  # broadcast
  def update_broadcast
    broadcast_replace_to [self, "admin_navbar"], target: "admin_navbar_dogrun_place_#{self.id}", partial: "admin/shared/navbar", locals: { current_user: User.where(role: "admin").find_by(dogrun_place: self) }
  end

end

# 1: grand_admin
# 2: 犬のしつけ広場
# 3: 里音(Re:on)

# == Schema Information
#
# Table name: dogrun_places
#
#  id              :bigint           not null, primary key
#  address         :string           default("")
#  closed_flag     :boolean          default(FALSE)
#  closing_time    :time
#  description     :text             default("")
#  force_closed    :boolean          default("releasing")
#  name            :string           not null
#  opening_time    :time
#  prefecture_code :integer
#  site_area       :string           default("")
#  usage_fee       :string           default("")
#  web_site        :string           default("")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
