class CatalogItems < ActiveRecord::Migration
  def change
    create_table :catalog_items do |t|

      t.integer :catalogable_id
      t.string  :catalogable_type
      t.string :name, :null => false
      t.string :number, :null => false
      t.string :dimensions
      t.string :weight
      t.attachment :image

      t.timestamps
    end
  end
end
