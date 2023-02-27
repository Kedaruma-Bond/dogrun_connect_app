class AddOptionToRegistrationNumber < ActiveRecord::Migration[7.0]
  def change
    change_column_null :registration_numbers, :dogrun_place_id, false
  end
end
