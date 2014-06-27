class Wishlist < ActiveRecord::Base

  belongs_to :user
  has_many :wishlist_items, :dependent => :destroy
  validates :name, :presence => true

  scope :public, -> { where(:public => true) }

  def public?
    public == true
  end

  def self.find_or_create(attributes)
    Wishlist.where(attributes).first || Wishlist.create(attributes)
  end

  def parts
    wishlist_items.where(catalog_item_type: 'catalog_part')
  end

  def sets
    wishlist_items.where(catalog_item_type: 'catalog_set')
  end

end
