class MoveToMoney < ActiveRecord::Migration
  def change
    remove_column :store_inventory_parts, :quantity_price
    remove_column :store_inventory_parts, :price
    remove_column :store_inventory_sets, :quantity_price
    remove_column :store_inventory_sets, :price

    add_money :store_inventory_parts, :quantity_price
    add_money :store_inventory_parts, :price
    add_money :store_inventory_sets, :quantity_price
    add_money :store_inventory_sets, :price
  end
end
