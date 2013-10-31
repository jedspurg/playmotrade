class StoreInventoryPart < ActiveRecord::Base

  include InventoryHelper

  belongs_to :store_inventory
  belongs_to :catalog_part
  has_one :store, :through => :store_inventory

  scope :active, -> { where("quantity > 0 AND price > 0")}

  CONDITIONS = ["New", "Used (Like New)", "Used (Good)", "Used (Acceptable)"]

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
