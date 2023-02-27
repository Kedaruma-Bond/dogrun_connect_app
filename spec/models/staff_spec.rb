require 'rails_helper'

RSpec.describe Staff, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      staff = build(:staff, :disable)
      expect(staff).to be_valid
    end
  end

  context 'nameがnilの場合' do
    example '無効であること' do
      staff = build(:staff, name: nil)
      expect(staff).to be_invalid
      expect(staff.errors).to be_of_kind(:name, :blank)
    end
  end
  
  describe 'emailフィールドについて' do
    context 'nilの場合' do
      example '無効であること' do
        staff = build(:staff, email: nil)
        expect(staff).to be_invalid
        expect(staff.errors).to be_of_kind(:email, :blank)
      end
    end

    context '様式が正しくない場合' do
      example '無効であること' do
        staff = build(:staff, email: 'henoheno.org')
        expect(staff).to be_invalid
        expect(staff.errors).to be_of_kind(:email, I18n.t('defaults.email_message'))
      end
    end
  end
  
  context 'enable_notificationがnilの場合' do
    example '無効であること' do
      staff = build(:staff, enable_notification: nil)
      expect(staff).to be_invalid
      expect(staff.errors).to be_of_kind(:enable_notification, :blank)
    end
  end
  
  context 'dogrun_placeがnilの場合' do
    example '無効であること' do
      staff = build(:staff, dogrun_place: nil)
      expect(staff).to be_invalid
      expect(staff.errors).to be_of_kind(:dogrun_place, :blank)
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
