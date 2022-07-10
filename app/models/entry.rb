class Entry < ApplicationRecord
  belongs_to :dog
  belongs_to :registration_number

  # validates
  validates :entry_at, presense: true
end

# == Schema Information
#
# Table name: entries
#
#  id                     :bigint           not null, primary key
#  entry_at               :date             not null
#  exit_at                :date
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  dog_id                 :bigint           not null
#  registration_number_id :bigint           not null
#
# Indexes
#
#  index_entries_on_dog_id                  (dog_id)
#  index_entries_on_registration_number_id  (registration_number_id)
#
# Foreign Keys
#
#  fk_rails_...  (dog_id => dogs.id)
#  fk_rails_...  (registration_number_id => registration_numbers.id)
#
