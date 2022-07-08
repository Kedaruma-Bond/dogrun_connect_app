require 'rails_helper'

RSpec.describe Contact, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      contact = build(:contact)
      expect(contact).to be_valid
    end
  end

  context 'nameが空欄の場合' do
    it '無効であること' do
      contact = build(:contact, name: nil)
      expect(contact).to be_invalid
      expect(contact.errors[:name]).to include('を入力してください')
    end
  end

  context 'emailが空欄の場合' do
    it '無効であること' do
      contact = build(:contact, email: nil)
      expect(contact).to be_invalid
      expect(contact.errors[:email]).to include('を入力してください')
    end
  end

  context 'emailの様式が正しくない場合' do
    it '無効であること' do
      contact = build(:contact, email: 'user_at_foo.org')
      expect(contact).to be_invalid
      expect(contact.errors[:email]).to include('の様式が正しくありません')
    end
  end

  context 'messageが空欄の場合' do
    it '無効であること' do
      contact = build(:contact, message: nil)
      expect(contact).to be_invalid
      expect(contact.errors[:message]).to include('を入力してください')
    end
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  message    :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
