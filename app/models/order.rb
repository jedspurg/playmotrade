class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  has_many :order_items

  validates :user, :store, :order_items, presence: true
end
