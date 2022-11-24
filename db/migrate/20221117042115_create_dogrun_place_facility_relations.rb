class CreateDogrunPlaceFacilityRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :dogrun_place_facility_relations do |t|
      t.references :dogrun_place, null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true

      t.timestamps
    end
  end
end
