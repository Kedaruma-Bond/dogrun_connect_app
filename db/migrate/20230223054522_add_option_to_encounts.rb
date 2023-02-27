class AddOptionToEncounts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :encounts, :entry_id, false
  end
end
