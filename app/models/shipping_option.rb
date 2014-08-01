class ShippingOption < ActiveRecord::Base

  VALID_SHIPPING_TYPES = ['free', 'flat_rate', 'by_item', 'by_weight']
  belongs_to :store
  belongs_to :country

  monetize :base_price_cents, with_model_currency: :base_price_currency

  validates :store_id, :country_id, :base_price_cents, :option, presence: true
end
