class AddPartsListToSets < ActiveRecord::Migration
  def change
    add_column :catalog_sets, :playmodb_inventory, :text
  end
end
