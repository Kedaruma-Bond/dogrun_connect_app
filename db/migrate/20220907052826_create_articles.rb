class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.references :post, null: false, foreign_key: true
      t.text :content, null: false
      t.string :image_attach

      t.timestamps
    end
  end
end
