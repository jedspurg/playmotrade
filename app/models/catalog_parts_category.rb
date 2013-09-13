class CatalogPartsCategory < ActiveRecord::Base
  has_many :catalog_parts
end