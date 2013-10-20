class Wishlist < ActiveRecord::Base

  belongs_to :user

  has_many :wishlist_items

  validates :name, :presence => true

  def self.find_or_create(attributes)
    Wishlist.where(attributes).first || Wishlist.create(attributes)
  end

end
