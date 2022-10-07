class FriendDog < ApplicationRecord

  # validates
  validates :memo, length: { maximum: 1000 }
  
  # enum
  enum color_marker: { transparent: 0, red: 1, green: 2, blue: 3, yellow: 4 }

  # scope


end

# == Schema Information
#
# Table name: friend_dogs
#
#  id              :bigint           not null, primary key
#  color_marker    :integer
#  memo            :text             default("")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  dogrun_place_id :bigint           not null
#
# Indexes
#
#  index_friend_dogs_on_dogrun_place_id  (dogrun_place_id)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#
