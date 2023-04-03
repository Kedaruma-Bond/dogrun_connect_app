require 'rails_helper'

RSpec.describe Contact, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      contact = build(:contact)
      expect(contact).to be_valid
    end
  end

  describe 'nameフィールドについて' do
    context '空欄の場合' do
      example '無効であること' do
        contact = build(:contact, name: nil)
        expect(contact).to be_invalid
        expect(contact.errors).to be_of_kind(:name, :blank)
      end
    end

    context '50字以上の場合' do
      example '無効であること' do
        contact = build(:contact, name: 'a' * 51)
        expect(contact).to be_invalid
        expect(contact.errors).to be_of_kind(:name, :too_long)
      end
    end
  end

  describe 'emailフィールドについて' do
    context '空欄の場合' do
      example '無効であること' do
        contact = build(:contact, email: nil)
        expect(contact).to be_invalid
        expect(contact.errors).to be_of_kind(:email, :blank)
      end
    end
  
    context '様式が正しくない場合' do
      example '無効であること' do
        contact = build(:contact, email: 'user_at_foo.org')
        expect(contact).to be_invalid
        expect(contact.errors).to be_of_kind(:email, I18n.t('defaults.email_message'))
      end
    end
  end

  describe 'messageフィールドについて' do
    context '空欄の場合' do
      example '無効であること' do
        contact = build(:contact, message: nil)
        expect(contact).to be_invalid
        expect(contact.errors).to be_of_kind(:message, :blank)
      end
    end
    
    context '1000字以上の場合' do
      example '無効であること' do
        contact = build(:contact, message: 'a' * 1001)
        expect(contact).to be_invalid
        expect(contact.errors).to be_of_kind(:message, :too_long)
      end
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
