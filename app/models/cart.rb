class Cart < ActiveRecord::Base

  belongs_to :user
  belongs_to :store

  has_many :cart_items

  after_initialize :check_item_availability

  def total_unique_items
    cart_items.count
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def total_cost
    total = 0.0
    cart_items.each do |item|
      total += (item.quantity * item.price.to_f)
    end
    total
  end

  def check_item_availability
    cart_items.each do |item|
      store_inventory_item = item.associated_class.find_by(:id => item.store_inventory_item_id)
      if store_inventory_item.blank?
        item.destroy
      end
      if store_inventory_item.present? && store_inventory_item.quantity < item.quantity
        item.update_attributes!({
          :modified => true,
          :quantity => store_inventory_item.quantity
          })
        errors.add(:item, "#{item.name} quantity was adjusted to #{item.quantity} to match the store's maximum available")
      end
    end
  end

end
