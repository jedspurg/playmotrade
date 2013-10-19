class CartItem < ActiveRecord::Base

  belongs_to :cart

  validates :cart_id, :presence => true
  validates :store_inventory_item_id, :presence => true
  validates :store_inventory_item_type, :presence => true
  validates :quantity, :presence => true
  validate :item_availability


  def item_availability
    item = store_inventory_item_type.camelize.constantize.find_by(:id => store_inventory_item_id)
    if quantity.to_i > item.quantity
      errors.add(:quanity, "#{quantity} is not available")
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

  def image
    associated_object.send(catalog_association).image.url(:thumb)
  end

  def condition
    associated_object.condition
  end

  def name
    associated_object.send(catalog_association).name
  end

  def number
    associated_object.send(catalog_association).number
  end

  def price
    associated_object.price
  end

  def total
    quantity * price
  end

end
