class RemoveDogrunFromRegistrationNumbers < ActiveRecord::Migration[7.0]
  def change
    remove_column :registration_numbers, :dogrun, :string
  end
end
