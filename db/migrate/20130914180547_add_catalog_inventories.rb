class AddCatalogInventories < ActiveRecord::Migration
  def change
    
    create_table :catalog_inventories do |t|
      t.integer :catalog_set_id, :null => false
      t.timestamps
    end

    create_table :catalog_inventory_parts do |t|
      t.integer :catalog_inventory_id, :null => false
      t.integer :catalog_part_id, :null => false
      t.integer :quantity
      t.timestamps
    end

  end
end
