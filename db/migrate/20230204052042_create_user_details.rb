class CreateUserDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :user_details do |t|
      t.string  :zip_code, null: false, limit: 8
      t.string  :address_1, null: false, limit: 50
      t.string  :address_2, limit: 50
      t.string  :phone_number, null: false, limit: 13
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
