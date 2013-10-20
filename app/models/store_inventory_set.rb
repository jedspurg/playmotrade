class StoreInventorySet < ActiveRecord::Base

  include InventoryHelper

  CONDITIONS = ["New (Sealed)", "New (Complete)", "New (Incomplete)", "Used (Complete)", "Used (Incomplete)"]

  belongs_to :store_inventory
  belongs_to :catalog_set
  has_one :store, :through => :store_inventory

  searchable do
    integer :store_inventory_id
    text :comment
    text :catalog_set_name do
      catalog_set.name
    end
    text :catalog_set_number do
      catalog_set.number
    end
  end

end
