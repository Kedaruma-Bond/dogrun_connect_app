class RegistrationNumber < ApplicationRecord
  belongs_to :dog
  belongs_to :dogrun_place
  has_many :entries, dependent: :destroy
  has_one :pre_entry, dependent: :destroy

  attr_accessor :select_dog, :agreement

  # validates
  validates :registration_number, presence: true, length: { maximum: 50 }
  validates :agreement, acceptance: true, on: :create
  validates :agreement, acceptance: true, on: :update, allow_blank: true
  validate :select_dog_validate
  
  # broadcast
  def create_broadcast
    broadcast_prepend_to [dogrun_place, "admin_dogs_index"], target: "admin_registration_numbers_dogrun_place_#{dogrun_place.id}", partial: "admin/registration_numbers/registration_number", locals: { registration_number: self, dogrun_place: dogrun_place, current_user: User.where(role: "admin").find_by(dogrun_place: dogrun_place) }
    broadcast_replace_to [dogrun_place, "admin_navbar"], target: "admin_navbar_dogrun_place_#{dogrun_place.id}", partial: "admin/shared/navbar", locals: { current_user: User.where(role: "admin").find_by(dogrun_place: dogrun_place) }
    broadcast_replace_to [dogrun_place, "admin_sidebar"], target: "admin_sidebar_dogrun_place_#{dogrun_place.id}", partial: "admin/shared/sidebar", locals: { current_user: User.where(role: "admin").find_by(dogrun_place: dogrun_place) }
  end

  def destroy_broadcast
    broadcast_remove_to [dogrun_place, "admin_dogs_index"], target: "registration_number_#{self.id}"
    broadcast_replace_to [dogrun_place, "admin_navbar"], target: "admin_navbar_dogrun_place_#{dogrun_place.id}", partial: "admin/shared/navbar", locals: { current_user: User.where(role: "admin").find_by(dogrun_place: dogrun_place) }
    broadcast_replace_to [dogrun_place, "admin_sidebar"], target: "admin_sidebar_dogrun_place_#{dogrun_place.id}", partial: "admin/shared/sidebar", locals: { current_user: User.where(role: "admin").find_by(dogrun_place: dogrun_place) }
  end

  # scope
  scope :dogrun_place_id, -> (id) { where(dogrun_place_id: id).includes(dog: { thumbnail_attachment: :blob,  rabies_vaccination_certificate_attachment: :blob, mixed_vaccination_certificate_attachment: :blob, license_plate_attachment: :blob } [:user]) }

  # ransack authorization
  def self.ransackable_attributes(auth_object = nil)
    ["acknowledge", "created_at", "dog_id", "dogrun_place_id", "id", "registration_number", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["dog", "user"]
  end

  private
    def select_dog_validate
      if dog_id.blank?
        errors.add(:select_dog, :unselected_option)
      end
    end
end

# == Schema Information
#
# Table name: registration_numbers
#
#  id                  :bigint           not null, primary key
#  acknowledge         :boolean          default(FALSE)
#  registration_number :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  dog_id              :bigint           not null
#  dogrun_place_id     :bigint           not null
#
# Indexes
#
#  index_registration_numbers_on_dog_id           (dog_id)
#  index_registration_numbers_on_dogrun_place_id  (dogrun_place_id)
#
# Foreign Keys
#
#  fk_rails_...  (dog_id => dogs.id)
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#
