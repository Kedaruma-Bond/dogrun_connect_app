class FriendDog < ApplicationRecord
  belongs_to :subject_dog, class_name: "Dog"
  belongs_to :friend_dog, class_name: "Dog"

  # validates
  validates :memo, length: { maximum: 1000 }
  
  # enum
  enum color_marker: { red: 0, green: 1, yellow: 2, blue: 3, pink: 4 }
end

# == Schema Information
#
# Table name: friend_dogs
#
#  id             :bigint           not null, primary key
#  color_marker   :integer
#  memo           :text             default("")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  friend_dog_id  :bigint           not null
#  subject_dog_id :bigint           not null
#
# Indexes
#
#  index_friend_dogs_on_friend_dog_id   (friend_dog_id)
#  index_friend_dogs_on_subject_dog_id  (subject_dog_id)
#
# Foreign Keys
#
#  fk_rails_...  (friend_dog_id => dogs.id)
#  fk_rails_...  (subject_dog_id => dogs.id)
#
