class AddCatalogParts < ActiveRecord::Migration
  def change
    create_table :catalog_parts do |t|

      t.string :color
      t.string :category
      t.attachment :alternate_image

      t.timestamps

    end
  end
end
