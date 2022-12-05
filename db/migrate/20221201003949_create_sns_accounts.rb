class CreateSnsAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :sns_accounts do |t|
      t.string :facebook_id
      t.string :instagram_id
      t.string :twitter_id
      t.references :user, foreign_key: true
      t.references :dogrun_place, foreign_key: true

      t.timestamps
    end
  end
end
