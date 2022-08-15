require 'rails_helper'

RSpec.describe User, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  context 'nameが空欄の場合' do
    it '無効であること' do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to include('を入力してください')
    end
  end

  context 'emailが空欄の場合' do
    it '無効であること' do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to include('を入力してください')
    end
  end

  context 'emailの様式が正しくない場合' do
    it '無効であること' do
      user = build(:user, email: 'user_at_foo.org')
      expect(user).to be_invalid
      expect(user.errors[:email]).to include('の様式が正しくありません')
    end
  end

  context 'passwordが空欄の場合' do
    it '無効であること' do
      user = build(:user, password: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to include('は6文字以上で入力してください')
    end
  end

  context 'password_confirmが空欄の場合' do
    it '無効であること' do
      user = build(:user, password_confirmation: nil)
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include('を入力してください')
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                  :bigint           not null, primary key
#  access_count_to_reset_password_page :integer          default(0)
#  crypted_password                    :string
#  deactivation                        :boolean          default(FALSE), not null
#  email                               :string           not null
#  enable_notification                 :boolean          default(FALSE), not null
#  failed_logins_count                 :integer          default(0)
#  lock_expires_at                     :datetime
#  name                                :string           not null
#  remember_me_token                   :string
#  remember_me_token_expires_at        :datetime
#  reset_password_email_sent_at        :datetime
#  reset_password_token                :string
#  reset_password_token_expires_at     :datetime
#  role                                :integer          default("general"), not null
#  salt                                :string
#  unlock_token                        :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  dogrun_place_id                     :bigint
#
# Indexes
#
#  index_users_on_dogrun_place_id       (dogrun_place_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_remember_me_token     (remember_me_token)
#  index_users_on_reset_password_token  (reset_password_token)
#  index_users_on_unlock_token          (unlock_token)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#
