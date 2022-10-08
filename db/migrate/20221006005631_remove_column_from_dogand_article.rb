class RemoveColumnFromDogandArticle < ActiveRecord::Migration[7.0]
  def change
    remove_column :dogs, :thumbnail_photo_tmp, :string
    remove_column :articles, :image_attach_tmp, :string
  end
end
