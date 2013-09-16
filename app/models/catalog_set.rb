class CatalogSet < ActiveRecord::Base
  acts_as :catalog_item, :as => :catalogable

  has_attached_file :back_image, :styles => { 
                                              :large  => "500x500>",
                                              :medium => "250x250>",
                                              :thumb  => "100x100>",
                                              :small  => "70x70>",
                                              :tiny  => "30x30>" 
                                            }, :default_url => "/images/items/:style/missing.png"

  default_scope{ order('number ASC') }

  def inventory
    CatalogInventory.where(:catalog_set_id => id).first
  end

end