class CreateStaffs < ActiveRecord::Migration[7.0]
  def change
    create_table :staffs do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :enable_notification, null: false, default: false
      t.references :dogrun_place, null: false, foreign_key: true
      t.timestamps
    end
  end
end
