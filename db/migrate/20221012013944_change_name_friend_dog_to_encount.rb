class ChangeNameFriendDogToEncount < ActiveRecord::Migration[7.0]
  def change
    rename_table :friend_dogs, :encounts
  end
end
