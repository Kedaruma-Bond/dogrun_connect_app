class AddColumnToDog < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :thumbnail_photo_tmp, :string
  end
end
