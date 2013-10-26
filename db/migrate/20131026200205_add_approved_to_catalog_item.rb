class AddApprovedToCatalogItem < ActiveRecord::Migration
  def change
    add_column :catalog_items, :approved, :boolean, :null => false, :default => false
    add_column :catalog_items, :approved_by, :integer
    add_column :catalog_items, :approved_at, :timestamp
    add_column :catalog_items, :submitted_by, :integer
  end
end
