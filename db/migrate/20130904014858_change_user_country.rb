class ChangeUserCountry < ActiveRecord::Migration
  def change
    rename_column :users, :country, :country_id
  end
end
