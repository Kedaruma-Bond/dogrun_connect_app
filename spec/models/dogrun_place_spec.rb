require 'rails_helper'

RSpec.describe DogrunPlace, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      dogrun_place = build(:dogrun_place)
      expect(dogrun_place).to be_valid
    end
  end

  context 'nameがnullの場合' do
    it '無効であること' do
      dogrun_place = build(:dogrun_place, name: nil)
      expect(dogrun_place).to be_invalid
      expect(dogrun_place.errors[:name]).to include('を入力してください')
    end
  end
end

# == Schema Information
#
# Table name: dogrun_places
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
