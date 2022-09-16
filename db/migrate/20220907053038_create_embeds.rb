class CreateEmbeds < ActiveRecord::Migration[7.0]
  def change
    create_table :embeds do |t|
      t.references :post, null: false, foreign_key: true
      t.text :identifier, null: false
      t.integer :embed_type, null: false

      t.timestamps
    end
  end
end
