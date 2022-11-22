class Facility < ApplicationRecord
  has_many :dogrun_place_facility_relations, dependent: :destroy
  has_many :dogrun_places, through: :dogrun_place_facility_relations, dependent: :destroy 

  # validation
  validates :name, presence: true, length: { maximum: 50 }
end

# == Schema Information
#
# Table name: facilities
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
