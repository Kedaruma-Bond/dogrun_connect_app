class CreateEncountDogs < ActiveRecord::Migration[7.0]
  def change
    create_table :encount_dogs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :dog,  null: false, foreign_key: true
      t.references :dogrun_place, null: false, foreign_key: true
      t.integer    :color_marker, default: ''
      t.text       :memo,         default: ''
      t.timestamps
    end
  end
end
