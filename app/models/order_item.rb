class OrderItem < ActiveRecord::Base
  belongs_to :order

  monetize :price_cents

  def catalog_class
    catalog_item_type.camelize.constantize
  end

  def catalog_object
    catalog_class.find_by(:id => catalog_item_id)
  end

  def store_inventory_association
    catalog_class.name.gsub("Catalog", "StoreInventory").camelize.constantize
  end

  def store_inventory_object
    store_inventory_association.find_by(:id => store_inventory_item_id)
  end

  def image(size=:thumb)
    catalog_object.image.url(size)
  end

  def condition
    store_inventory_object.condition
  end

  def name
    catalog_object.name
  end

  def number
    catalog_object.number
  end

  def total
    quantity * price
  end
end
