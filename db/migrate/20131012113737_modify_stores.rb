class ModifyStores < ActiveRecord::Migration
  def change
    add_column :stores, :active, :boolean
    add_column :stores, :alias, :string
    add_attachment :stores, :logo
  end
end
