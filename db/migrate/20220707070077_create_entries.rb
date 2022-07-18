class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :dog, null: false, foreign_key: true
      t.references :registration_number, null: false, foreign_key: true
      t.datetime :entry_at, null: false
      t.datetime :exit_at

      t.timestamps
    end
    add_index :entries, %i[dog_id registration_number_id entry_at], unique: true, name: 'registration_dog_entry_time_index'
  end
end
