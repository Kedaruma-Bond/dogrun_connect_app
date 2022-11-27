class AddColumnToDogsForVacctination < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :date_of_mixed_vaccination, :date, default: ''
    add_column :dogs, :date_of_rabies_vaccination, :date, default: ''
    add_column :dogs, :registration_municipality, :string, default: ''
    add_column :dogs, :municipal_registration_number, :integer, default: ''
    add_column :dogs, :registration_prefecture_code, :integer, default: ''
  end
end
