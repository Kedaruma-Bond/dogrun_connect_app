class ChangeColumnNameInDogrunPlace < ActiveRecord::Migration[7.0]
  def change
    rename_column :dogrun_places, :twitter, :twitter_id
  end
end
