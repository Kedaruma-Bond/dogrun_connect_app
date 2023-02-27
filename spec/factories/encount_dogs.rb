FactoryBot.define do
  factory :encount_dog do
    association :dog
    association :dogrun_place
    association :user

    trait :acknowledged do
      acknowledge { true }
    end
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
