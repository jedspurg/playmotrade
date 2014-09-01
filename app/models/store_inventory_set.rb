class StoreInventorySet < ActiveRecord::Base

  include InventoryHelper

  belongs_to :store_inventory
  belongs_to :catalog_set
  has_one :store, :through => :store_inventory

  monetize :quantity_price_cents
  monetize :price_cents
  monetize :shipping_price_cents

  scope :active, -> { where("quantity > 0 AND price_cents > 0")}

  CONDITIONS = ["New (Sealed)", "New (Complete)", "New (Incomplete)", "Used (Complete)", "Used (Incomplete)"]

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

  def catalog_item_id
    catalog_set.catalog_item.id
  end

  def catalog_item_type
    'CatalogSet'
  end

end
