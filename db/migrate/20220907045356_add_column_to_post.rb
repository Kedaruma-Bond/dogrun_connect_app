class AddColumnToPost < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :postable, polymorphic: true
  end
end
