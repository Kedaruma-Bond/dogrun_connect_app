class Entry < ApplicationRecord
  belongs_to :dog
  belongs_to :registration_number
  has_many :encounts, dependent: :destroy

  attr_accessor :select_dog, :pre_flg

  # validations
  validates :entry_at, presence: true

  # delegate
  delegate :dogrun_place, to: :registration_number
  # scope
  scope :admin_dogrun_place_id, -> (dogrun_place_id) { includes(:registration_number, dog: { thumbnail_attachment: :blob }).eager_load(dog: [:user]).where(registration_numbers: { dogrun_place_id: dogrun_place_id }).order(entry_at: :desc) }
  scope :dogrun_place_id, -> (dogrun_place_id) { includes(:registration_number, dog: { thumbnail_attachment: :blob }).eager_load(dog: [:user]).where(registration_numbers: { dogrun_place_id: dogrun_place_id }).order(entry_at: :desc).where(dogs: { public: 'public_view'} ) }
  scope :user_id, -> (user_id) { includes(dog: [:user]).where(dogs: { user_id: user_id }) }
  scope :user_id_at_local, -> (user_id) { includes(:dog, :registration_number).where(dogs: { user_id: user_id }) }
  scope :dogrun_place_id_for_encount_dog, -> (dogrun_place_id) { joins(:registration_number).includes(:dog).where(exit_at: nil).where(registration_number: { dogrun_place_id: dogrun_place_id }) }

  # broadcast
  after_update_commit do
    broadcast_remove_to [dogrun_place, "top"], target: "entry_dog_#{self.dog.id}_dogrun_place_#{self.dogrun_place.id}"
    broadcast_replace_to [dogrun_place, "admin_entries_index"], target: "entry_#{self.id}", partial: "admin/entries/entry", locals: { entry: self }
  end
  
  after_destroy_commit do
    broadcast_remove_to [dogrun_place, "top"], target: "entry_dog_#{self.dog.id}_dogrun_place_#{self.dogrun_place.id}"
    broadcast_remove_to [dogrun_place, "admin_entries_index"], target: "entry_#{self.id}"
    broadcast_remove_to [dogrun_place, "entries_index"], target: "entry_#{self.id}"
  end

  after_create_commit do
    broadcast_prepend_to [dogrun_place, "admin_entries_index"], target: "admin_entries_dogrun_place_#{dogrun_place.id}", partial: "admin/entries/entry", locals: { entry: self }
  end

  def entry_broadcast_for_top(dog, current_user, dogrun_place, dog_profile_path)
    broadcast_append_to [dogrun_place, "top"], target: "entries_list_dogrun_place_#{dogrun_place.id}", partial: "shared/entry_dog", locals: { dog: dog, current_user: current_user, dogrun_place: dogrun_place, dog_profile_path: dog_profile_path }
  end

  def exit_broadcast(dog_profile_path, entry_path, current_user)
    broadcast_replace_to [dogrun_place, "entries_index"], target: "entry_#{self.id}", partial: "shared/entry", locals: { dog_profile_path: dog_profile_path, entry_path: entry_path, current_user: current_user }
  end

  def update_broadcast(num_of_playing_dogs, dogs_non_public)
    broadcast_update_to [dogrun_place, "top"], target: "num_of_playing_dogs_dogrun_place_#{dogrun_place.id}", partial: "shared/num_of_playing_dogs", locals: { num_of_playing_dogs: num_of_playing_dogs }
    broadcast_update_to [dogrun_place, "top"], target: "among_them_non_public_dogs_dogrun_place_#{dogrun_place.id}", partial: "shared/among_them_non_public_dogs", locals: { dogs_non_public: dogs_non_public }
    broadcast_update_to [dogrun_place, "admin_entries_index"], target: "admin_num_of_playing_dogs_dogrun_place_#{dogrun_place.id}", partial: "admin/entries/num_of_playing_dogs", locals: { num_of_playing_dogs: num_of_playing_dogs }
  end

  # ransack authorization
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "dog_id", "entry_at", "entry_digest", "exit_at", "id", "registration_number_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["dog", "encounts", "registration_number"]
  end
end

# == Schema Information
#
# Table name: entries
#
#  id                     :bigint           not null, primary key
#  entry_at               :datetime         not null
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
