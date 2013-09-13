class AddPartsSubcategories < ActiveRecord::Migration
  def change
    CatalogScraper::PLAYMODB_PART_CATEGORIES.each do |category|
      main_category = category.split('-').first.gsub('%20', ' ')
      main_category = 'Uncategorized' if main_category == ('TO BE ASSIGNED' || '%3F')
      sub_category  = category.split('-').last.gsub('%20', ' ') if category.split('-').count > 1

      catalog_parts_category = CatalogPartsCategory.find_by(:name => main_category)

      if sub_category.present?
        CatalogPartsSubcategory.create!({
          :name                      => sub_category,
          :catalog_parts_category_id => catalog_parts_category.id
        })
      end

    end
  end
end
