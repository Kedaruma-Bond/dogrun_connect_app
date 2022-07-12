require 'rails_helper'

RSpec.describe RegistrationNumber, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      registration_number = build(:registration_number)
      expect(registration_number).to be_valid
    end
  end

  context 'dogrun_placeが空欄の場合' do
    it '無効であること' do
      registration_number = build(:registration_number, dogrun_place: nil)
      expect(registration_number).to be_invalid
      expect(registration_number.errors[:dogrun_place]).to include('を入力してください')
    end
  end

  context 'registration_numberがnullの場合' do
    it '無効であること' do
      registration_number = build(:registration_number, registration_number: nil)
      expect(registration_number).to be_invalid
      expect(registration_number.errors[:registration_number]).to include('を入力してください')
    end
  end
end
