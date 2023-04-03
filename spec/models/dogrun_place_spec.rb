require 'rails_helper'

RSpec.describe DogrunPlace, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      dogrun_place = build(:dogrun_place)
      expect(dogrun_place).to be_valid
    end
  end

  describe 'nameフィールドについて' do
    context 'nilの場合' do
      example '無効であること' do
        dogrun_place = build(:dogrun_place, name: nil)
        expect(dogrun_place).to be_invalid
        expect(dogrun_place.errors).to be_of_kind(:name, :blank)
      end
    end

    context '50字以上の場合' do
      example '無効であること' do
        dogrun_place = build(:dogrun_place, name: 'a' * 51)
        expect(dogrun_place).to be_invalid
        expect(dogrun_place.errors).to be_of_kind(:name, :too_long)
      end
    end
  end

  describe 'descriptionフィールドについて' do
    context '1000字以上の場合' do
      example '無効であること' do
        dogrun_place = build(:dogrun_place, description: 'a' * 1001)
        expect(dogrun_place).to be_invalid
        expect(dogrun_place.errors).to be_of_kind(:description, :too_long)
      end
    end
  end
  
  describe 'logoフィールドについて' do
    context '10MB以上の場合' do
      before do
        @dogrun_place = build(:dogrun_place)
        @dogrun_place.logo = fixture_file_upload('/images/test_image.jpg')
      end
      example '無効であること' do
        expect(@dogrun_place).to be_invalid
        expect(@dogrun_place.errors).to be_of_kind(:logo, :file_size_out_of_range)
      end
    end

    context 'ファイル形式がtiffの場合' do
      before do
        @dog = build(:dog, :castrated, :public_view, :male)
        @dog.thumbnail = fixture_file_upload('/images/test_image_tiff.tiff')
      end
      example '無効であること' do
        expect(@dog).to be_invalid
        expect(@dog.errors).to be_of_kind(:thumbnail, :content_type_invalid)
      end
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
#  force_closed    :boolean          default("releasing")
#  name            :string           not null
#  opening_time    :time
#  prefecture_code :integer
#  site_area       :string           default("")
#  usage_fee       :string           default("")
#  web_site        :string           default("")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
