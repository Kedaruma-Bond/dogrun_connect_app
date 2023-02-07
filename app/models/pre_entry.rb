class PreEntry < ApplicationRecord
  belongs_to :dog
  belongs_to :registration_number

  attr_accessor :select_dog

  # delegate
  delegate :dogrun_place, to: :registration_number

  # scope
  scope :user_id_at_local, -> (user_id) { includes(:dog, :registration_number).where(dogs: { user_id: user_id }) }

  # broadcast
  after_destroy_commit do
    broadcast_remove_to [dogrun_place, "top"], target: "pre_entry_dog_#{self.dog.id}_dogrun_place_#{self.dogrun_place.id}"
  end

  def pre_entry_broadcast(dog, current_user, dogrun_place, dog_profile_path)
    broadcast_append_to [dogrun_place, "top"], target: "pre_entries_list_dogrun_place_#{dogrun_place.id}", partial: "shared/pre_entry_dog", locals: { pre_entry_dog: dog, current_user: current_user, dogrun_place: dogrun_place, dog_profile_path: dog_profile_path }
  end
end

# == Schema Information
#
# Table name: pre_entries
#
#  id                     :bigint           not null, primary key
#  minutes_passed_count   :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  dog_id                 :bigint           not null
#  registration_number_id :bigint           not null
#
# Indexes
#
#  index_pre_entries_on_dog_id                  (dog_id)
#  index_pre_entries_on_registration_number_id  (registration_number_id)
#
# Foreign Keys
#
#  fk_rails_...  (dog_id => dogs.id)
#  fk_rails_...  (registration_number_id => registration_numbers.id)
#
