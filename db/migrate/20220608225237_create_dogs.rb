class CreateDogs < ActiveRecord::Migration[7.0]
  def change
    create_table :dogs do |t|
      t.string :option
      t.string :name,         null: false
      t.boolean :castration,  null: false, default: false
      t.boolean :public,      null: false, default: false
      t.boolean :sex,         null: false, default: false
      t.string :breed
      t.date :birthday
      t.integer :weight
      t.text :owner_comment
      t.reference :user, foreign_key: true

      t.timestamps
    end
  end
end
