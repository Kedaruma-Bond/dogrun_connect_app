class AddColumnToDogForApproval < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :filming_approval, :boolean
    add_column :dogs, :sns_post_approval, :boolean
  end
end
