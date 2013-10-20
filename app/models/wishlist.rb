class Wishlist < ActiveRecord::Base

  belongs_to :user

  has_many :wishlist_items

  validates :name, :presence => true

end
