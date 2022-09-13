class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.text :content, null: false
      t.string :image_attach

      t.timestamps
    end
  end
end
