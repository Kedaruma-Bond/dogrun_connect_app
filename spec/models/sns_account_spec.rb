require 'rails_helper'

RSpec.describe SnsAccount, type: :model do
  describe 'created by user' do
    context '全てのフィールドが有効な場合' do
      example '有効であること' do
        sns_account = build(:sns_account, :created_by_user)
        expect(sns_account).to be_valid
      end
    end

    context '全てのフィールドが空欄の場合' do
      example '無効であること' do
        sns_account = build(:sns_account, :created_by_user, twitter_id: "", facebook_id: "", instagram_id: "")
        expect(sns_account).to be_invalid
        expect(sns_account.errors).to be_of_kind(:base, I18n.t('defaults.input_any_one_sns_account'))
      end
    end

    context 'どれか一つでも入力されている場合' do
      example '有効であること' do
        sns_account = build(:sns_account, :created_by_user, twitter_id: "", facebook_id: "")
        expect(sns_account).to be_valid
      end
    end
  end
  
  describe 'created by dogrun place' do
    context '全てのフィールドが有効な場合' do
      example '有効であること' do
        sns_account = build(:sns_account, :created_by_dogrun_place)
        expect(sns_account).to be_valid
      end
    end

    context '全てのフィールドが空欄の場合' do
      example '無効であること' do
        sns_account = build(:sns_account, :created_by_dogrun_place, twitter_id: "", facebook_id: "", instagram_id: "")
        expect(sns_account).to be_invalid
        expect(sns_account.errors).to be_of_kind(:base, I18n.t('defaults.input_any_one_sns_account'))
      end
    end

    context 'どれか一つでも入力されている場合' do
      example '有効であること' do
        sns_account = build(:sns_account, :created_by_dogrun_place, twitter_id: "", facebook_id: "")
        expect(sns_account).to be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: sns_accounts
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  dogrun_place_id :bigint
#  facebook_id     :string
#  instagram_id    :string
#  twitter_id      :string
#  user_id         :bigint
#
# Indexes
#
#  index_sns_accounts_on_dogrun_place_id  (dogrun_place_id)
#  index_sns_accounts_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#  fk_rails_...  (user_id => users.id)
#
