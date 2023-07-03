class EncountDog < ApplicationRecord
  belongs_to :dogrun_place
  belongs_to :user
  belongs_to :dog

  # validates
  validates :memo, length: { maximum: 1000 }
  
  # enum
  enum color_marker: { transparent: 0, red: 1, green: 2, blue: 3, yellow: 4 }

  # scope
  scope :encount_dog_of_user, -> (user_id) { joins(:dogrun_place, :dog).includes(dog: { thumbnail_attachment: :blob }).where(user_id: user_id).where(dogs: { public: 'public_view' }).order(created_at: :desc)} 

  # ransack authorization
  def self.ransackable_attributes(auth_object = nil)
    ["acknowledge", "color_marker", "created_at", "dog_id", "dogrun_place_id", "id", "memo", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["dog", "dogrun_place", "user"]
  end
end

# == Schema Information
#
# Table name: encount_dogs
#
#  id              :bigint           not null, primary key
#  acknowledge     :boolean          default(FALSE), not null
#  color_marker    :integer
#  memo            :text             default("")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  dog_id          :bigint           not null
#  dogrun_place_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_encount_dogs_on_dog_id           (dog_id)
#  index_encount_dogs_on_dogrun_place_id  (dogrun_place_id)
#  index_encount_dogs_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (dog_id => dogs.id)
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#  fk_rails_...  (user_id => users.id)
#
