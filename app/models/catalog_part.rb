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

  has_many :catalog_sets, :through => :catalog_inventory_parts

  default_scope{ order('number ASC') }

  scope :color, Proc.new { |color|
    where(:color => color)
  }

  searchable do
    text :name, :number, :color
  end

  def in_sets
    inventory_ids = CatalogInventoryPart.where(:catalog_part_id => id).pluck(:catalog_inventory_id)
    set_ids = CatalogInventory.where(:id => inventory_ids).pluck(:catalog_set_id)
    CatalogSet.where(:id => set_ids)
  end

  def available_for_sale
    StoreInventoryPart.where(:catalog_part_id => id)
  end

end
