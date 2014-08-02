class AddWeightPriceToShippingOptions < ActiveRecord::Migration
  def change
    add_money :shipping_options, :per_gram_price
  end
end
