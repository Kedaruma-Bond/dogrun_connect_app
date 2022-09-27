class AddRefFriendDog < ActiveRecord::Migration[7.0]
  def change
    add_reference :friend_dogs, :dogrun_place, null: false, foreign_key: true
  end
end
