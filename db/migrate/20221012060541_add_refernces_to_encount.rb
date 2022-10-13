class AddReferncesToEncount < ActiveRecord::Migration[7.0]
  def change
    add_reference :encounts, :entry, foreign_key: true
  end
end
