class StoreInventoryPart < ActiveRecord::Base

  include InventoryHelper

  belongs_to :store_inventory
  belongs_to :catalog_part
  has_one :store, :through => :store_inventory

  monetize :quantity_price_cents
  monetize :price_cents
  monetize :shipping_price_cents

  scope :active, -> { where("quantity > 0 AND price_cents > 0")}

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

  def catalog_item_id
    catalog_part.catalog_item.id
  end

  def catalog_item_type
    'CatalogPart'
  end

end
