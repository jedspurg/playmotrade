class CatalogInventory < ActiveRecord::Base

  belongs_to :catalog_set

  has_many :catalog_parts

  def list
    CatalogInventoryPart.where(:catalog_inventory_id => id).all
  end
end