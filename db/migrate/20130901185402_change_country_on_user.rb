class ChangeCountryOnUser < ActiveRecord::Migration
  def change
  	 remove_column :users, :country
  	 add_column :users, :country, :integer
    
  end
end
