require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { build(:contact) }

  it 'モデルが存在すること' do
    expect(contact).to be_valid
  end

  it '氏名が空欄では作成不可であること' do
    contact.name = ''
    expect(contact).to be_invalid
  end

  it 'メールアドレスが空欄では作成不可であること' do
    contact.email = ''
    expect(contact).to be_invalid
  end

  it '内容が空欄では作成不可であること' do
    contact.message = ''
    expect(contact).to be_invalid
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
