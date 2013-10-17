class StoreInventoryPart < ActiveRecord::Base

  belongs_to :store_inventory
  belongs_to :catalog_part

  CONDITIONS = ["New", "Used"]

  searchable do
    integer :store_inventory_id
    text :comment
    text :catalog_part_name do
      catalog_part.name
    end
    text :catalog_part_number do
      catalog_part.number
    end
  end

end
