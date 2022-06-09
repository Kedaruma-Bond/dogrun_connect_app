class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name,             null: false
      t.string :email,            null: false
      t.integer :dogrun_place,    null: false, default: 0
      t.boolean :deactivation,    null: false, default: false
      t.boolean :enable_notification, null: false, default: false
      t.string :crypted_password
      t.string :salt

      t.timestamps null: false
    end
    add_index :users, %i[email dogrun_place], unique: true
  end
end
