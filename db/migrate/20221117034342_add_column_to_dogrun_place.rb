class AddColumnToDogrunPlace < ActiveRecord::Migration[7.0]
  def change
    add_column :dogrun_places, :description, :text, default: '', limit: 1000
    add_column :dogrun_places, :usage_fee, :string, default: ''
    add_column :dogrun_places, :prefecture_code, :integer
    add_column :dogrun_places, :address, :string, default: ''
    add_column :dogrun_places, :site_area, :string, default: ''
    add_column :dogrun_places, :web_site, :string, default: ''
    add_column :dogrun_places, :opening_time, :time, default: ''
    add_column :dogrun_places, :closing_time, :time, default: ''
    add_column :dogrun_places, :closed_flag, :boolean, default: false
    add_column :dogrun_places, :force_closed, :boolean, default: false
  end
end
