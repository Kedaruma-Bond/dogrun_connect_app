class CreatePreEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :pre_entries do |t|
      t.references :dog, null: false, foreign_key: true
      t.references :registration_number, null: false, foreign_key: true
      t.integer :minutes_passed_count, null: false, default: 0

      t.timestamps
    end
  end
end
