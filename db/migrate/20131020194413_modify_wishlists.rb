class ModifyWishlists < ActiveRecord::Migration
  def change
    add_column :wishlists, :description, :string, :null => true
    add_column :wishlists, :notification, :string, :default => 'never'
  end
end
