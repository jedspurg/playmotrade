class WishlistItem < ActiveRecord::Base

  belongs_to :wishlist

  def catalog_object
    catalog_item_type.camelize.constantize.find(catalog_item_id)
  end

  def image(size=:thumb)
    catalog_object.image.url(size)
  end

  def name
    catalog_object.name
  end

  def number
    catalog_object.number
  end

  def color
    catalog_object.try(:color)
  end

end
