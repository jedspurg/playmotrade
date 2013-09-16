class CatalogInventoryPart < ActiveRecord::Base

  belongs_to :catalog_part
  belongs_to :catalog_inventory

end