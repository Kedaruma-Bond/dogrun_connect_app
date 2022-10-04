class FriendDog < ApplicationRecord
  belongs_to :subject_dog, class_name: "Dog"
  belongs_to :friend_dog, class_name: "Dog"

  # validates
  validates :memo, length: { maximum: 1000 }
  
  # enum
  enum color_marker: { transparent: 0, red: 1, green: 2, blue: 3, yellow: 4 }

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
#  friend_dog_id   :bigint           not null
#  subject_dog_id  :bigint           not null
#
# Indexes
#
#  index_friend_dogs_on_dogrun_place_id  (dogrun_place_id)
#  index_friend_dogs_on_friend_dog_id    (friend_dog_id)
#  index_friend_dogs_on_subject_dog_id   (subject_dog_id)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#  fk_rails_...  (friend_dog_id => dogs.id)
#  fk_rails_...  (subject_dog_id => dogs.id)
#
