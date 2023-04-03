require 'rails_helper'

RSpec.describe EncountDog, type: :model do
  describe 'validations' do
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

  describe 'scope' do
    let(:user) { create(:user, :general) }
    let(:dogrun_place) { create(:dogrun_place) }
    let!(:dog_1) { create(:dog, :castrated, :public_view) }
    let!(:dog_2) { create(:dog, :castrated, :non_public) }

    before do
      user.encount_dogs.create(dog: dog_1, dogrun_place: dogrun_place)
      user.encount_dogs.create(dog: dog_2, dogrun_place: dogrun_place)
    end

    context 'scope :encount_dog_of_user' do
      example '正常に動作すること' do
        expect(EncountDog.encount_dog_of_user(user.id)).to include(EncountDog.find_by(dog: dog_1))
        expect(EncountDog.encount_dog_of_user(user.id)).not_to include(EncountDog.find_by(dog: dog_2))
      end
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
