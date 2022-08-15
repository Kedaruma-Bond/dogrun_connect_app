class RenameDogrunPlaceColumnToRegistrationNumbers < ActiveRecord::Migration[7.0]
  def change
    rename_column :registration_numbers, :dogrun_place, :dogrun
  end
end
