class Cart < ActiveRecord::Base

  belongs_to :user
  belongs_to :store

  has_many :cart_items

  def total_unique_items
    total = 0
    total += cart_items.count
  end

  def total_items
    total = 0
    total += cart_items.sum(:quantity)
  end

  def total_cost
    total = 0.0
    cart_items.each do |item|
      associated_item = item.store_inventory_item_type.camelize.constantize.find_by(:id => item.store_inventory_item_id)
      total += (item.quantity * associated_item.price.to_f)
    end
    total
  end

end
