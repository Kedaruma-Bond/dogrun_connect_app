class AddReferenceToFriendDog < ActiveRecord::Migration[7.0]
  def change
    add_reference :friend_dogs, :user, foreign_key: true, null: false
    add_reference :friend_dogs, :dog, foreign_key: true, null: false
  end
end
