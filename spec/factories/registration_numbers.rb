FactoryBot.define do
  factory :registration_number do
    registration_number { Faker::Number.between(from: 1, to: 2000) }
    association :dog
    association :dogrun_place
  end
end

# == Schema Information
#
# Table name: registration_numbers
#
#  id                  :bigint           not null, primary key
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
