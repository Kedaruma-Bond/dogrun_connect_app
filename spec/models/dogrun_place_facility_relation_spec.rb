require 'rails_helper'

RSpec.describe DogrunPlaceFacilityRelation, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      dogrun_place_facility_relation = build(:dogrun_place_facility_relation)
      expect(dogrun_place_facility_relation).to be_valid
    end
  end

  context 'dogrun_placeがnilの場合' do
    example '無効であること' do
      dogrun_place_facility_relation = build(:dogrun_place_facility_relation, dogrun_place: nil)
      expect(dogrun_place_facility_relation).to be_invalid
      expect(dogrun_place_facility_relation.errors).to be_of_kind(:dogrun_place, :blank)
    end
  end

  context 'facilityがnilの場合' do
    example '無効であること' do
      dogrun_place_facility_relation = build(:dogrun_place_facility_relation, facility: nil)
      expect(dogrun_place_facility_relation).to be_invalid
      expect(dogrun_place_facility_relation.errors).to be_of_kind(:facility, :blank)
    end
  end
end
