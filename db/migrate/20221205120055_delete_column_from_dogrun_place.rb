class DeleteColumnFromDogrunPlace < ActiveRecord::Migration[7.0]
  def change
    remove_column :dogrun_places, :facebook_id, :string
    remove_column :dogrun_places, :instagram_id, :string
    remove_column :dogrun_places, :twitter_id, :string
  end
end
