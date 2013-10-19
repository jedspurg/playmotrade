class StoreInventory < ActiveRecord::Base

  belongs_to :store
  has_many :store_inventory_parts
  has_many :store_inventory_sets

  def total_sets
    store_inventory_sets.sum(:quantity)
  end

  def total_parts
    store_inventory_parts.sum(:quantity)
  end

  def total_parts_by_category(category_id)
    total = 0
    parts = store_inventory_parts.select{|part| part.catalog_part.catalog_parts_category.try(:id) == category_id}
    parts.each do |part|
      total += part.quantity
    end
    total
  end

  def part_categories
    categories = store_inventory_parts.map do |part|
      part.catalog_part.catalog_parts_category.id rescue nil
    end
    categories.uniq.compact
  end

  def all_items
    store_inventory_sets + store_inventory_parts
  end

end
