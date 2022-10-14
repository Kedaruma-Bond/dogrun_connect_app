class AddColumnToEncountDog < ActiveRecord::Migration[7.0]
  def change
    add_column :encount_dogs, :acknowledge, :boolean, null: false, default: false
  end
end
