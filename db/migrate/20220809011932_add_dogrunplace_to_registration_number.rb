class AddDogrunplaceToRegistrationNumber < ActiveRecord::Migration[7.0]
  def change
    add_reference :registration_numbers, :dogrun_place, foreign_key: true
  end
end
