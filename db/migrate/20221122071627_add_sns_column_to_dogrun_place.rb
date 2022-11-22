class AddSnsColumnToDogrunPlace < ActiveRecord::Migration[7.0]
  def change
    add_column :dogrun_places, :facebook_id, :string, default: ''
    add_column :dogrun_places, :instagram_id, :string, default: ''
    add_column :dogrun_places, :twitter, :string, default: ''
  end
end
