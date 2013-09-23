class CatalogTag < ActiveRecord::Base
  belongs_to :catalog_item
  belongs_to :tag
end