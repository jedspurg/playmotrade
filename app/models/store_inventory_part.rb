class StoreInventoryPart < ActiveRecord::Base

  belongs_to :store_inventory
  belongs_to :catalog_part

  CONDITIONS = ["New", "Used"]

end
