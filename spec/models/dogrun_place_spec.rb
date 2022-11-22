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
#  id              :bigint           not null, primary key
#  address         :string           default("")
#  closed_flag     :boolean          default(FALSE)
#  closing_time    :time
#  description     :text             default("")
#  force_closed    :boolean          default(FALSE)
#  name            :string           not null
#  opening_time    :time
#  prefecture_code :integer
#  site_area       :string           default("")
#  twitter         :string           default("")
#  usage_fee       :string           default("")
#  web_site        :string           default("")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  facebook_id     :string           default("")
#  instagram_id    :string           default("")
#
