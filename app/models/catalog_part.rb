class CatalogPart < ActiveRecord::Base
  acts_as :catalog_item, :as => :catalogable

  has_attached_file :alternate_image, :styles => { 
                                              :large  => "500x500>",
                                              :medium => "250x250>",
                                              :thumb  => "100x100>",
                                              :small  => "70x70>",
                                              :tiny  => "30x30>" 
                                            }, :default_url => "/images/items/:style/missing.png"

  belongs_to :catalog_parts_category
  belongs_to :catalog_parts_subcategory

  scope :color, Proc.new { |color|
    where(:color => color)
  }

end