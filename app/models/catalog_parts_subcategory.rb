class CatalogPartsSubcategory < ActiveRecord::Base
  has_many :catalog_parts
  belongs_to :catalog_parts_category
end