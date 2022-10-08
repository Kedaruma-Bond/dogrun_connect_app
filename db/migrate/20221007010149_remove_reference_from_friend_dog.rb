class RemoveReferenceFromFriendDog < ActiveRecord::Migration[7.0]
  def change
    remove_reference :friend_dogs, :subject_dog, foreign_key: { to_table: 'dogs' } 
    remove_reference :friend_dogs, :friend_dog, foreign_key: { to_table: 'dogs' }
  end
end
