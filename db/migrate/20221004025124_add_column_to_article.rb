class AddColumnToArticle < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :image_attach_tmp, :string
  end
end
