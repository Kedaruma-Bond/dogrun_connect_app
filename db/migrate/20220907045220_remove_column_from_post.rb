class RemoveColumnFromPost < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :attach_image, :string
    remove_column :posts, :content, :text
  end
end
