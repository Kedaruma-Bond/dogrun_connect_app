class DeleteCarrierwaveColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :dogs, :thumbnail_photo, :string
    remove_column :articles, :image_attach, :string
  end
end
