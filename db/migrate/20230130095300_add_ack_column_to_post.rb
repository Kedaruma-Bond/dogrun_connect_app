class AddAckColumnToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :acknowledge, :boolean, default: :false
  end
end
