class AddShipppingOptions < ActiveRecord::Migration
  def change
    create_table :shipping_options do |t|
      t.references :store, :null => false
      t.references :country, :null => false
      t.decimal :tax, :precision => 6, :scale => 2
      t.money :base_price, :null => false, :default => 0
      t.string :option, :null => false, :default => 'free'

      t.timestamps
    end
  end
end
