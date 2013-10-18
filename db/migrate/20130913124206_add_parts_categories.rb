class AddPartsCategories < ActiveRecord::Migration
  def change
    create_table :catalog_parts_categories do |t|

      t.string :name
      t.timestamps

    end

    rename_column :catalog_parts, :category, :playmodb_category
    add_column :catalog_parts, :category_id, :integer

    ["123", "Animal", "Building", "Cloth", "Decoration", "Furniture", "Humanoid", "Klicky", "Micro",
     "Paper", "Plant", "Scenery", "Support", "Uncategorized", "Tool", "Vehicle", "Wearable"].each do |category|
      CatalogPartsCategory.create!({
        :name => category
        })
    end

  end
end
