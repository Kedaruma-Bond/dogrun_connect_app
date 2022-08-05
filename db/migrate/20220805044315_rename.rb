class Rename < ActiveRecord::Migration[7.0]
  def change
    rename_column :dogs, :thumbnail_image, :thumbnail_photo
  end
end
