class Entry < ApplicationRecord
  belongs_to :dog
  belongs_to :registration_number
  has_many :encounts, dependent: :destroy

  attr_accessor :select_dog, :pre_flg

  #validations
  validates :entry_at, presence: true

  # scope
  scope :admin_dogrun_place_id, -> (dogrun_place_id) { includes(:registration_number, dog: { thumbnail_attachment: :blob }).eager_load(dog: [:user]).where(registration_numbers: { dogrun_place_id: dogrun_place_id }).order(entry_at: :desc) }
  scope :dogrun_place_id, -> (dogrun_place_id) { includes(:registration_number, dog: { thumbnail_attachment: :blob }).eager_load(dog: [:user]).where(registration_numbers: { dogrun_place_id: dogrun_place_id }).order(entry_at: :desc).where(dogs: { public: 'public_view'} ) }
  scope :user_id, -> (user_id) { includes(dog: [:user]).where(dogs: { user_id: user_id }) }
  scope :user_id_at_local, -> (user_id) { includes(:dog, :registration_number).where(dogs: { user_id: user_id }) }

  # broadcast
  # after_create_commit do

  # end

end

# == Schema Information
#
# Table name: entries
#
#  id                     :bigint           not null, primary key
#  entry_at               :datetime         not null
#  entry_digest           :string
#  exit_at                :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  dog_id                 :bigint           not null
#  registration_number_id :bigint           not null
#
# Indexes
#
#  index_entries_on_dog_id                  (dog_id)
#  index_entries_on_registration_number_id  (registration_number_id)
#  registration_dog_entry_time_index        (dog_id,registration_number_id,entry_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (dog_id => dogs.id)
#  fk_rails_...  (registration_number_id => registration_numbers.id)
#
