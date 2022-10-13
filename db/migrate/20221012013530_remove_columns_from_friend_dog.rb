class RemoveColumnsFromFriendDog < ActiveRecord::Migration[7.0]
  def change
    remove_column :friend_dogs, :memo, :text
    remove_column :friend_dogs, :color_marker, :integer
  end
end
