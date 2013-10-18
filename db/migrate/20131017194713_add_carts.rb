class AddCarts < ActiveRecord::Migration
  def change

    create_table :carts do |t|
      t.integer :user_id, :null => false
      t.integer :store_id, :null => false
      t.boolean :checked_out
      t.timestamps
    end

    create_table :cart_items do |t|
      t.integer :cart_id, :null => false
      t.integer :store_inventory_item_id, :null => false
      t.string :store_inventory_item_type, :null => false
      t.integer :quantity
      t.timestamps
    end

  end
end
