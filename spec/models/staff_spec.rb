require 'rails_helper'

RSpec.describe Staff, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      staff = build(:staff, :disable)
      expect(staff).to be_valid
    end
  end

  context 'nameがnullの場合' do
    it '無効であること' do
      staff = build(:staff, name: nil)
      expect(staff).to be_invalid
      expect(staff.errors[:name]).to include('を入力してください')
    end
  end
  
  context 'emailがnullの場合' do
    it '無効であること' do
      staff = build(:staff, email: nil)
      expect(staff).to be_invalid
      expect(staff.errors[:email]).to include('を入力してください')
    end
  end
  
  context 'enable_notificationがnullの場合' do
    it '無効であること' do
      staff = build(:staff, enable_notification: nil)
      expect(staff).to be_invalid
      expect(staff.errors[:enable_notification]).to include('を入力してください')
    end
  end
  
  context 'dogrun_placeがnullの場合' do
    it '無効であること' do
      staff = build(:staff, dogrun_place: nil)
      expect(staff).to be_invalid
      expect(staff.errors[:dogrun_place]).to include('を入力してください')
    end
  end
end


# == Schema Information
#
# Table name: staffs
#
#  id                  :bigint           not null, primary key
#  email               :string           not null
#  enable_notification :boolean          default("disable"), not null
#  name                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  dogrun_place_id     :bigint           not null
#
# Indexes
#
#  index_staffs_on_dogrun_place_id  (dogrun_place_id)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#
