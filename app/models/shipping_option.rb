class ShippingOption < ActiveRecord::Base

  VALID_SHIPPING_TYPES = ['free', 'flat_rate', 'by_item', 'by_weight']
  belongs_to :store
  belongs_to :country

  monetize :base_price_cents, with_model_currency: :base_price_currency
  monetize :per_gram_price_cents, with_model_currency: :per_gram_price_currency

  validates :store_id, :country_id, :base_price_cents, :option, presence: true

  def calculate_shipping(cart)
    @cart  = cart
    @total = Money.new(0, base_price_currency) + base_price
    public_send(:"calculate_#{option}")

    @total
  end

  def calculate_by_weight
    @cart.cart_items.each do |item|
      @total += (item.catalog_object.weight * per_gram_price * item.quantity)
    end
  end

  def calculate_by_item
    @cart.cart_items.each do |item|
      @total += (item.associated_object.shipping_price.exchange_to(base_price_currency) * item.quantity)
    end
  end

  def calculate_free
    @total - base_price
  end

  def calculate_flat_rate
    @total
  end
end
