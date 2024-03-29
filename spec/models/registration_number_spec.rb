require 'rails_helper'

RSpec.describe RegistrationNumber, type: :model do
  context '全てのフィールドが有効な場合' do
    let!(:dog) { create(:dog, :public_view, :castrated) }
    example '有効であること' do
      registration_number = build(:registration_number, dog: dog)
      expect(registration_number).to be_valid
    end
  end

  context 'dogrun_placeがnilの場合' do
    example '無効であること' do
      registration_number = build(:registration_number, dogrun_place: nil)
      expect(registration_number).to be_invalid
      expect(registration_number.errors).to be_of_kind(:dogrun_place, :blank)
    end
  end

  describe 'registration_numberフィールドについて' do
    context 'nilの場合' do
      example '無効であること' do
        registration_number = build(:registration_number, registration_number: nil)
        expect(registration_number).to be_invalid
        expect(registration_number.errors).to be_of_kind(:registration_number, :blank)
      end
    end

    context '50字以上の場合' do
      example '無効であること' do
        registration_number = build(:registration_number, registration_number: 'a' * 51)
        expect(registration_number).to be_invalid
        expect(registration_number.errors).to be_of_kind(:registration_number, :too_long)
      end
    end
  end

  context 'dogがnilの場合' do
    example '無効であること' do
      registration_number = build(:registration_number, dog: nil)
      expect(registration_number).to be_invalid
      expect(registration_number.errors).to be_of_kind(:dog, :blank)
    end
  end
end

# == Schema Information
#
# Table name: registration_numbers
#
#  id                  :bigint           not null, primary key
#  acknowledge         :boolean          default(FALSE)
#  registration_number :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  dog_id              :bigint           not null
#  dogrun_place_id     :bigint           not null
#
# Indexes
#
#  index_registration_numbers_on_dog_id           (dog_id)
#  index_registration_numbers_on_dogrun_place_id  (dogrun_place_id)
#
# Foreign Keys
#
#  fk_rails_...  (dog_id => dogs.id)
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#
