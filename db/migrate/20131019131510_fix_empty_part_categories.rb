class FixEmptyPartCategories < ActiveRecord::Migration
  def change
    CatalogPart.where('catalog_parts_category_id IS NULL').each do |part|
      category = part.playmodb_category.split('-').first rescue "Uncategorized"
      if category == "Uncategorized" && part.number.first == "k"
        category = "Klicky"
      end
      if category == "Uncategorized" && part.number.first == "i"
        category = "Paper"
      end
      part.update_attributes!({
        :catalog_parts_category => CatalogPartsCategory.find_by(:name => category)
      })
    end
  end
end
