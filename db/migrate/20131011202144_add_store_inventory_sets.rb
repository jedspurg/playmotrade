class AddStoreInventorySets < ActiveRecord::Migration

  create_table :store_inventory_sets do |t|
    t.integer :store_inventory_id, :null => false
    t.integer :catalog_set_id, :null => false
    t.integer :quantity, :null => false, :default => 0
    t.boolean :quantity_discount
    t.integer :quantity_minimum_for_discount
    t.decimal :quantity_price, :precision => 6, :scale => 2
    t.decimal :price, :precision => 6, :scale => 2
    t.string  :condition
    t.text    :comment
    t.attachment :custom_image
    t.timestamps
  end

end
