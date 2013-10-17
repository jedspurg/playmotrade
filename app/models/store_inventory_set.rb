class StoreInventorySet < ActiveRecord::Base

  belongs_to :store_inventory
  belongs_to :catalog_set

  searchable do
    integer :store_inventory_id
    text :comment
    text :catalog_set_name do
      catalog_part.name
    end
    text :catalog_set_number do
      catalog_part.number
    end
  end

end
