class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content,    null: false
      t.string :attach_image
      t.boolean :publish_status,  null: false, default: false
      t.references :dogrun_place, null: false, foreign_key: true
      t.timestamps
    end
  end
end
