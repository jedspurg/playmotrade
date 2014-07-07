class AddPlaymotradeFeeToOrders < ActiveRecord::Migration
  def change
    add_money :orders, :application_fee
  end
end
