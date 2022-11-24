class DogrunPlaceFacilityRelation < ApplicationRecord
  belongs_to :dogrun_place
  belongs_to :facility
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
