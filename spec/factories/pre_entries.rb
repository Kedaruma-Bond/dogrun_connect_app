FactoryBot.define do
  factory :pre_entry do
    association :dog
    association :registration_number
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
