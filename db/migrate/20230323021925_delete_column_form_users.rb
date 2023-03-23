class DeleteColumnFormUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :facebook_id, :string
    remove_column :users, :instagram_id, :string
    remove_column :users, :twitter_id, :string
  end
end
