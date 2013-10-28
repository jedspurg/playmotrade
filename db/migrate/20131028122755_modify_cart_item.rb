class ModifyCartItem < ActiveRecord::Migration
  def change
    add_column :cart_items, :modified, :boolean, :default => false
  end
end
