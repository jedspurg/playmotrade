class CartItem < ActiveRecord::Base

  belongs_to :cart

  validates :cart_id, :presence => true
  validates :store_inventory_item_id, :presence => true
  validates :store_inventory_item_type, :presence => true
  validates :quantity, :presence => true
  validate :item_availability

  def update_store_inventory_item!
    new_quantity = associated_object.quantity - quantity
    if new_quantity >= 0
      associated_object.update_attributes!(quantity: new_quantity)
    else
      errors.add(:quanity, "#{quantity} is not available for #{name}.")
    end
  end

  def item_availability
    if quantity.to_i > associated_object.quantity
      errors.add(:quanity, "#{quantity} is not available for this item.")
    end
  end

  def associated_class
    store_inventory_item_type.camelize.constantize
  end

  def associated_object
    associated_class.find_by(:id => store_inventory_item_id)
  end

  def catalog_association
    associated_class.name.gsub("StoreInventory", "Catalog").underscore.downcase
  end

  def catalog_object
    associated_object.send(catalog_association)
  end

  def image(size=:thumb)
    catalog_object.image.url(size)
  end

  def condition
    associated_object.condition
  end

  def name
    catalog_object.name
  end

  def number
    catalog_object.number
  end

  def price
    associated_object.price
  end

  def total
    quantity * price
  end

end
