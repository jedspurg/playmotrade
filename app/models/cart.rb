  class Cart < ActiveRecord::Base

  belongs_to :user
  belongs_to :store

  has_many :cart_items

  scope :open, -> { where(:checked_out => false) }
  scope :not_empty, -> { joins(:cart_items).group('carts.id').having("COUNT(cart_items.cart_id) > 0") }

  def total_unique_items
    cart_items.count
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def total_cost
    total = Money.new(0)
    cart_items.each do |item|
      total += (item.quantity * item.price)
    end
    total
  end

  def check_item_availability
    items_deleted = false
    cart_items.each do |item|
      store_inventory_item = item.associated_class.find_by(:id => item.store_inventory_item_id)
      if store_inventory_item.blank?
        item.destroy
        items_deleted = true
      end
      if store_inventory_item.present? && store_inventory_item.quantity < item.quantity
        item.update_attributes!({
          :modified => true,
          :quantity => store_inventory_item.quantity
          })
        errors.add(:item, "#{item.number}:#{item.name} quantity was adjusted to #{item.quantity} to match the store's maximum available")
      end
    end
    if items_deleted
      errors.add(:base, "Some items were deleted from your cart because they are no longer available in this store")
    end
  end

  # TODO - Make this work...
  def calculate_shipping(shipping_option_id=nil)
    Money.new(5)
  end

end
