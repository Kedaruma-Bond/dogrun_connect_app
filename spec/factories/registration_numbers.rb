FactoryBot.define do
  factory :registration_number do
    
  end
end

# == Schema Information
#
# Table name: registration_numbers
#
#  id                  :bigint           not null, primary key
#  dogrun_place        :integer          not null
#  registration_number :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  dog_id              :bigint           not null
#
# Indexes
#
#  index_registration_numbers_on_dog_id  (dog_id)
#
# Foreign Keys
#
#  fk_rails_...  (dog_id => dogs.id)
#
