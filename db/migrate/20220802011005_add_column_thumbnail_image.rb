class AddColumnThumbnailImage < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :thumbnail_image, :string
  end
end
