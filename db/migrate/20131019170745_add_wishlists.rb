class AddWishlists < ActiveRecord::Migration
  def change

    create_table :wishlists do |t|
      t.string :name, :null => false
      t.integer :user_id, :null => false
      t.boolean :public, :null => false, :default => false
      t.timestamps
    end

    create_table :wishlist_items do |t|
      t.integer :wishlist_id, :null => false
      t.integer :catalog_item_id, :null => false
      t.string :catalog_item_type, :null => false
      t.integer :min_quantity, :null => false, :default => 1
      t.timestamps
    end

  end
end
