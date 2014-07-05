class OrderItem < ActiveRecord::Base
  belongs_to :order

  monetize :price_cents
end
