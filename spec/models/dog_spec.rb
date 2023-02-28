require 'rails_helper'

RSpec.describe Dog, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      dog = build(:dog, :castrated, :public_view, :male)
      expect(dog).to be_valid
    end
  end

  describe 'nameフィールドについて' do
    context '空欄の場合' do
      example '無効であること' do
        dog = build(:dog, :non_castrated, :non_public, name: nil)
        expect(dog).to be_invalid
        expect(dog.errors).to be_of_kind(:name, :blank)
      end
    end

    context '50字以上の場合' do
      example '無効であること' do
        dog = build(:dog, :non_castrated, :non_public, name: 'a' * 51)
        expect(dog).to be_invalid
        expect(dog.errors).to be_of_kind(:name, :too_long)
      end
    end

  end

  context 'castrationがnilの場合' do
    example '無効であること' do
      dog = build(:dog, :public_view, castration: nil)
      expect(dog).to be_invalid
      expect(dog.errors).to be_of_kind(:castration, :blank)
    end
  end

  context 'publicがnilの場合' do
    example '無効であること' do
      dog = build(:dog, :castrated, public: nil)
      expect(dog).to be_invalid
      expect(dog.errors).to be_of_kind(:public, :blank)
    end
  end

  context 'breedが50字以上の場合' do
    example '無効であること' do
      dog = build(:dog, :castrated, breed: 'a' * 51)
      expect(dog).to be_invalid
      expect(dog.errors).to be_of_kind(:breed, :too_long)
    end
  end

  context 'weightが0未満の場合' do
    example '無効であること' do
      dog = build(:dog, :castrated, weight: -1)
      expect(dog).to be_invalid
      expect(dog.errors).to be_of_kind(:weight, :greater_than)
    end
  end

  context 'owner_commentが400字以上の場合' do
    example '無効であること' do
      dog = build(:dog, :castrated, owner_comment: 'a' * 401)
      expect(dog).to be_invalid
      expect(dog.errors).to be_of_kind(:owner_comment, :too_long)
    end
  end

  describe 'thumbnailフィールドについて' do
    context '10MB以上の場合' do
      before do
        @dog = build(:dog, :castrated, :public_view, :male)
        @dog.thumbnail = fixture_file_upload('/images/test_image.jpg')
      end
      example '無効であること' do
        expect(@dog).to be_invalid
        expect(@dog.errors).to be_of_kind(:thumbnail, :file_size_out_of_range)
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
  
  describe 'mixed_vaccination_certificateフィールドについて' do
    context '10MB以上の場合' do
      before do
        @dog = build(:dog, :castrated, :public_view, :male)
        @dog.mixed_vaccination_certificate = fixture_file_upload('/images/test_image.jpg')
      end
      example '無効であること' do
        expect(@dog).to be_invalid
        expect(@dog.errors).to be_of_kind(:mixed_vaccination_certificate, :file_size_out_of_range)
      end
    end

    context 'ファイル形式がtiffの場合' do
      before do
        @dog = build(:dog, :castrated, :public_view, :male)
        @dog.mixed_vaccination_certificate = fixture_file_upload('/images/test_image_tiff.tiff')
      end
      example '無効であること' do
        expect(@dog).to be_invalid
        expect(@dog.errors).to be_of_kind(:mixed_vaccination_certificate, :content_type_invalid)
      end
    end
  end
  
  describe 'rabies_vaccination_certificateフィールドについて' do
    context '10MB以上の場合' do
      before do
        @dog = build(:dog, :castrated, :public_view, :male)
        @dog.rabies_vaccination_certificate = fixture_file_upload('/images/test_image.jpg')
      end
      example '無効であること' do
        expect(@dog).to be_invalid
        expect(@dog.errors).to be_of_kind(:rabies_vaccination_certificate, :file_size_out_of_range)
      end
    end

    context 'ファイル形式がtiffの場合' do
      before do
        @dog = build(:dog, :castrated, :public_view, :male)
        @dog.rabies_vaccination_certificate = fixture_file_upload('/images/test_image_tiff.tiff')
      end
      example '無効であること' do
        expect(@dog).to be_invalid
        expect(@dog.errors).to be_of_kind(:rabies_vaccination_certificate, :content_type_invalid)
      end
    end
  end
  
  describe 'license_plateフィールドについて' do
    context '10MB以上の場合' do
      before do
        @dog = build(:dog, :castrated, :public_view, :male)
        @dog.license_plate = fixture_file_upload('/images/test_image.jpg')
      end
      example '無効であること' do
        expect(@dog).to be_invalid
        expect(@dog.errors).to be_of_kind(:license_plate, :file_size_out_of_range)
      end
    end

    context 'ファイル形式がtiffの場合' do
      before do
        @dog = build(:dog, :castrated, :public_view, :male)
        @dog.license_plate = fixture_file_upload('/images/test_image_tiff.tiff')
      end
      example '無効であること' do
        expect(@dog).to be_invalid
        expect(@dog.errors).to be_of_kind(:license_plate, :content_type_invalid)
      end
    end
  end

  context 'registration_municipalityが30字以上の場合' do
    example '無効であること' do
      dog = build(:dog, :castrated, registration_municipality: 'a' * 31)
      expect(dog).to be_invalid
      expect(dog.errors).to be_of_kind(:registration_municipality, :too_long)
    end
  end
  
  context 'municipal_registration_numberが10字以上の場合' do
    example '無効であること' do
      dog = build(:dog, :castrated, municipal_registration_number: '1' * 11)
      expect(dog).to be_invalid
      expect(dog.errors).to be_of_kind(:municipal_registration_number, :too_long)
    end
  end

  context 'userがnilの場合' do
    example '無効であること' do
      dog = build(:dog, user: nil)
      expect(dog).to be_invalid
      expect(dog.errors).to be_of_kind(:user, :blank)
    end
  end
end

# == Schema Information
#
# Table name: dogs
#
#  id                            :bigint           not null, primary key
#  birthday                      :date
#  breed                         :string           default("")
#  castration                    :boolean          not null
#  date_of_mixed_vaccination     :date
#  date_of_rabies_vaccination    :date
#  filming_approval              :boolean
#  municipal_registration_number :integer
#  name                          :string           not null
#  owner_comment                 :text             default("")
#  public                        :boolean          not null
#  registration_municipality     :string           default("")
#  registration_prefecture_code  :integer
#  sex                           :integer
#  sns_post_approval             :boolean
#  weight                        :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :bigint           not null
#
# Indexes
#
#  index_dogs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
