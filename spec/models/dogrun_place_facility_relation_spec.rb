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

# == Schema Information
#
# Table name: dogrun_place_facility_relations
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  dogrun_place_id :bigint           not null
#  facility_id     :bigint           not null
#
# Indexes
#
#  index_dogrun_place_facility_relations_on_dogrun_place_id  (dogrun_place_id)
#  index_dogrun_place_facility_relations_on_facility_id      (facility_id)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#  fk_rails_...  (facility_id => facilities.id)
#
