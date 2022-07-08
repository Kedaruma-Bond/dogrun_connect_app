class CreateRegistrationNumbers < ActiveRecord::Migration[7.0]
  def change
    create_table :registration_numbers do |t|
      t.integer :dogrun_place,        null: false
      t.string :registration_number,  null: false
      t.references :dog,              null: false, foreign_key: true
      t.timestamps
    end
  end
end
