class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.money :total
      t.money :shipping
      t.references :store
      t.references :user
    end

    create_table :order_items do |t|
      t.money :price
      t.references :store
      t.references :order
      t.integer :store_inventory_item_id
      t.string :store_inventory_item_type
    end
  end
end
