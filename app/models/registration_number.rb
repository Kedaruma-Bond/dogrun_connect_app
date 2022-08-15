class RegistrationNumber < ApplicationRecord
  belongs_to :dog
  belongs_to :dogrun_place
  has_many :entries

  self.ignored_columns = [:dogrun_place] 
  # validates
  validates :registration_number, presence: true, numericality: true

  # enum
  enum dogrun: { togo_inu_shitsuke_hiroba: 0, dog_with: 1 }
end

# == Schema Information
#
# Table name: registration_numbers
#
#  id                  :bigint           not null, primary key
#  dogrun              :integer          not null
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
