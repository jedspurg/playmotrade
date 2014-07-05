class Order < ActiveRecord::Base
  belongs_to :user, :store
  #has_many :order_items
end
