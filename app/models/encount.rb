class Encount < ApplicationRecord
  belongs_to :dogrun_place
  belongs_to :user
  belongs_to :dog

  # validates
  
  # enum

  # scope

end

# == Schema Information
#
# Table name: encounts
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  dog_id          :bigint           not null
#  dogrun_place_id :bigint           not null
#  entry_id        :bigint
#  user_id         :bigint           not null
#
# Indexes
#
#  index_encounts_on_dog_id           (dog_id)
#  index_encounts_on_dogrun_place_id  (dogrun_place_id)
#  index_encounts_on_entry_id         (entry_id)
#  index_encounts_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (dog_id => dogs.id)
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (user_id => users.id)
#
