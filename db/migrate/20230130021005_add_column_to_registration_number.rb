class AddColumnToRegistrationNumber < ActiveRecord::Migration[7.0]
  def change
    add_column :registration_numbers, :acknowledge, :boolean, default: false
  end
end
