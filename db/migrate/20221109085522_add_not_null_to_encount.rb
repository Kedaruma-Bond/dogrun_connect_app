class AddNotNullToEncount < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :encounts, column: :entry_id
    add_foreign_key :encounts, :entries, null: false, foreign_key: true
  end
end
