class Store < ActiveRecord::Base
  
  belongs_to :user
  has_one :store_inventory
  validates :name, :presence => true, :uniqueness => true
  validates :user, :presence => true, :uniqueness => true
  validates :store_inventory, :presence => true, :uniqueness => true

  default_scope order('name ASC')

end