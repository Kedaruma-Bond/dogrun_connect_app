class CreateDogs < ActiveRecord::Migration[7.0]
  def change
    create_table :dogs do |t|
      t.string :name,     null: false
      t.boolean :castration,  null: false
      t.boolean :public,      null: false
      t.string :breed,        default: ''
      t.integer :sex,         default: ''
      t.date :birthday,       default: ''
      t.integer :weight,      default: ''
      t.text :owner_comment,  default: ''
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
