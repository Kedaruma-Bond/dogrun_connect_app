class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :dog, null: false, foreign_key: true
      t.references :registration_number, null: false, foreign_key: true
      t.date :entry_at, null: false
      t.date :exit_at

      t.timestamps
    end
  end
end
