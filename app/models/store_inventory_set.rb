class StoreInventorySet < ActiveRecord::Base

  belongs_to :store_inventory
  belongs_to :catalog_set

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
