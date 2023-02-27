require 'rails_helper'

RSpec.describe UserDetail, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      user_detail = build(:user_detail)
      expect(user_detail).to be_valid
    end
  end

  describe 'zip_codeフィールドについて' do
    context '空欄の場合' do
      example '無効であること' do
        user_detail = build(:user_detail, zip_code: '')
        expect(user_detail).to be_invalid
        expect(user_detail.errors).to be_of_kind(:zip_code, :blank)
      end
    end

    context '無効な値の場合' do
      example '無効であること' do
        user_detail = build(:user_detail, zip_code: '77777')
        expect(user_detail).to be_invalid
        expect(user_detail.errors).to be_of_kind(:zip_code, :invalid)
      end
    end
  end

  describe 'address_1フィールドについて' do
    context '空欄の場合' do
      example '無効であること' do
        user_detail = build(:user_detail, address_1: '')
        expect(user_detail).to be_invalid
        expect(user_detail.errors).to be_of_kind(:address_1, :blank)
      end
    end

    context '50字以上の場合' do
      example '無効であること' do
        user_detail = build(:user_detail, address_1: 'a' * 51)
        expect(user_detail).to be_invalid
        expect(user_detail.errors).to be_of_kind(:address_1, :too_long)
      end
    end
  end

  describe 'address_2フィールドについて' do
    context '空欄の場合' do
      example '有効であること' do
        user_detail = build(:user_detail, address_2: '')
        expect(user_detail).to be_valid
      end
    end
  end

  describe 'phone_numberフィールドについて' do
    context '空欄の場合' do
      example '無効であること' do
        user_detail = build(:user_detail, phone_number: '')
        expect(user_detail).to be_invalid
        expect(user_detail.errors).to be_of_kind(:phone_number, :blank)
      end
    end

    context '無効な値の場合' do
      example '無効であること' do
        user_detail = build(:user_detail, phone_number: '9021')
        expect(user_detail).to be_invalid
        expect(user_detail.errors).to be_of_kind(:phone_number, :invalid)
      end
    end
  end
end

# == Schema Information
#
# Table name: user_details
#
#  id           :bigint           not null, primary key
#  address_1    :string(50)       not null
#  address_2    :string(50)
#  phone_number :string(13)       not null
#  zip_code     :string(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_user_details_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
