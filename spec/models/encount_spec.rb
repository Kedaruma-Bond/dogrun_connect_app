require 'rails_helper'

RSpec.describe Encount, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      encount = build(:encount)
      expect(encount).to be_valid
    end
  end
  
  context 'dogrun_placeがnilの場合' do
    example '無効であること' do
      encount = build(:encount, dogrun_place: nil)
      expect(encount).to be_invalid
      expect(encount.errors).to be_of_kind(:dogrun_place, :blank)
    end
  end
  
  context 'dogがnilの場合' do
    example '無効であること' do
      encount = build(:encount, dog: nil)
      expect(encount).to be_invalid
      expect(encount.errors).to be_of_kind(:dog, :blank)
    end
  end

  context 'userがnilの場合' do
    example '無効であること' do
      encount = build(:encount, user: nil)
      expect(encount).to be_invalid
      expect(encount.errors).to be_of_kind(:user, :blank)
    end
  end

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
#  entry_id        :bigint           not null
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
