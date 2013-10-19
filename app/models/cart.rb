class Cart < ActiveRecord::Base

  belongs_to :user
  belongs_to :store

  has_many :cart_items

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

end
