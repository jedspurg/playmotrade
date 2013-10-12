class StoreInventory < ActiveRecord::Base

  belongs_to :store
  has_many :store_inventory_parts
  has_many :store_inventory_sets

  def total_sets
    StoreInventorySet.where( :id => store_inventory_sets.ids ).sum :quantity
  end

  def total_parts
    StoreInventoryPart.where( :id => store_inventory_parts.ids ).sum :quantity
  end

end
