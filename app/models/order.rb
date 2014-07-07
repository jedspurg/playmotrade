class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  has_many :order_items, :dependent => :destroy

  VALID_STATES = ['open', 'pending', 'canceled', 'shipped']

  validates :user, :store, :order_items, presence: true
  validates :order_items, presence: true, on: :update
  validates :status, inclusion: { in: VALID_STATES }

  monetize :total_cents
  monetize :shipping_cents
  monetize :application_fee
end
