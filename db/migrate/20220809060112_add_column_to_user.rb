class AddColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, default: 0, null: false
    add_reference :users, :dogrun_place, null: true, foreign_key: true
  end
end
