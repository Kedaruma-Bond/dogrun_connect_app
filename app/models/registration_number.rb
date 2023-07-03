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
  
  # ransack authorization
  def self.ransackable_attributes(auth_object = nil)
    ["acknowledge", "created_at", "dog_id", "dogrun_place_id", "id", "registration_number", "updated_at"]
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
