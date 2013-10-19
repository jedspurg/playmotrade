class ModifyCarts < ActiveRecord::Migration
  def change

    change_column :carts, :checked_out, :boolean, :default => false

  end
end
