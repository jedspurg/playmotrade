class StoreInventory < ActiveRecord::Base

  belongs_to :store
  has_many :store_inventory_parts
  has_many :store_inventory_sets

  def total_sets
    store_inventory_sets.sum :quantity
  end

  def total_parts
    store_inventory_parts.sum :quantity
  end

  def part_categories
    categories = store_inventory_parts.map do |part|
      part.catalog_part.catalog_parts_category.name rescue "Uncategorized"
    end
    categories.uniq.compact.sort
  end

  def all_items
    store_inventory_sets + store_inventory_parts
  end

end
