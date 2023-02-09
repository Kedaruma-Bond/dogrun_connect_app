class RegistrationNumber < ApplicationRecord
  belongs_to :dog
  belongs_to :dogrun_place
  has_many :entries, dependent: :destroy
  has_one :pre_entry, dependent: :destroy

  attr_accessor :select_dog

  # validates
  validates :registration_number, presence: true
  
  # scope
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
#  dogrun_place_id     :bigint
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
