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

end
