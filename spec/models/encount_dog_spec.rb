require 'rails_helper'

RSpec.describe EncountDog, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      encount_dog = build(:encount_dog)
      expect(encount_dog).to be_valid
    end
  end

  context 'dogrun_placeがnilの場合' do
    example '無効であること' do
      encount_dog = build(:encount_dog, dogrun_place: nil)
      expect(encount_dog).to be_invalid
      expect(encount_dog.errors).to be_of_kind(:dogrun_place, :blank)
    end
  end
  
  context 'dogがnilの場合' do
    example '無効であること' do
      encount_dog = build(:encount_dog, dog: nil)
      expect(encount_dog).to be_invalid
      expect(encount_dog.errors).to be_of_kind(:dog, :blank)
    end
  end

  context 'userがnilの場合' do
    example '無効であること' do
      encount_dog = build(:encount_dog, user: nil)
      expect(encount_dog).to be_invalid
      expect(encount_dog.errors).to be_of_kind(:user, :blank)
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
