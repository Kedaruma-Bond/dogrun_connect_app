class AddColumnsToUserForSnsId < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :facebook_id, :string, default: ''
    add_column :users, :instagram_id, :string, default: ''
    add_column :users, :twitter_id, :string, default: ''
  end
end
