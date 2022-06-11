class CreateDogs < ActiveRecord::Migration[7.0]
  def change
    create_table :dogs do |t|
      t.string :dog_name,     null: false
      t.boolean :castration,  null: false, default: false
      t.boolean :public,      null: false, default: false
      t.string :breed,        default: ''
      t.date :birthday,       default: '2020/1/1'
      t.integer :weight,      default: ''
      t.text :owner_comment,  default: ''
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
