class CatalogItems < ActiveRecord::Migration
  def change
    create_table :catalog_items, :as_relation_superclass => true  do |t|

      t.string :name, :null => false
      t.string :number, :null => false
      t.string :dimensions
      t.string :weight
      t.attachment :image

      t.timestamps
    end
  end
end
