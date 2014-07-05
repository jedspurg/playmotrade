class ModifyOrderAnd < ActiveRecord::Migration
  def change
    remove_column :order_items, :store_inventory_item_type, :string

    add_column :orders, :status, :string, :null => false, :default => 'open'
    add_column :orders, :created_at, :datetime, :null => false
    add_column :orders, :updated_at, :datetime, :null => false
    add_column :order_items, :created_at, :datetime, :null => false
    add_column :order_items, :updated_at, :datetime, :null => false
    add_column :order_items, :catalog_item_type, :string, :null => false
    add_column :order_items, :catalog_item_id, :integer, :null => false
    add_column :order_items, :quantity, :integer, :null => false
  end
end
