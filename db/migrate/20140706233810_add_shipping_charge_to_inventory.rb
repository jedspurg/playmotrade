class AddShippingChargeToInventory < ActiveRecord::Migration
  def change
    add_money :store_inventory_parts, :shipping_price
    add_money :store_inventory_sets, :shipping_price
  end
end

