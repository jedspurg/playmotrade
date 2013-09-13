class ConvertPartsCategories < ActiveRecord::Migration
  def change

    rename_column :catalog_parts, :category_id, :catalog_parts_category_id
    add_column :catalog_parts, :catalog_parts_subcategory_id, :integer

    CatalogPart.all.each do |part|
      category = part.playmodb_category
      main_category = category.split('-').first.gsub('%20', ' ')
      main_category = 'Uncategorized' if main_category == ('TO BE ASSIGNED' || '%3F')
      sub_category  = category.split('-').last.gsub('%20', ' ') if category.split('-').count > 1

      catalog_parts_category    = CatalogPartsCategory.find_by(:name => main_category)
      catalog_parts_subcategory = CatalogPartsSubcategory.find_by(:name => sub_category)
      
      part.update_attributes!({
        :catalog_parts_subcategory_id => catalog_parts_subcategory.try(:id),
        :catalog_parts_category_id    => catalog_parts_category.try(:id)
      })

    end


  end
end
