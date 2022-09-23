class CreateFriendDogs < ActiveRecord::Migration[7.0]
  def change
    create_table :friend_dogs do |t|
      t.references :subject_dog, null: false, foreign_key: { to_table: 'dogs'}
      t.references :friend_dog,  null: false, foreign_key: { to_table: 'dogs'}
      t.integer :color_marker,   default: ''
      t.text :memo,              default: ''
      t.timestamps
    end
  end
end
