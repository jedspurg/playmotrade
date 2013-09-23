class AddCompleteAndVerifiedOnCatalogInventor < ActiveRecord::Migration
  def change
    add_column :catalog_inventories, :complete, :boolean, :default => false
    add_column :catalog_inventories, :verified, :boolean, :default => false
  end
end
