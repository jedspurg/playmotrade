class Order < ActiveRecord::Base

  VALID_STATES   = ['open', 'pending shipment', 'canceled', 'shipped', 'completed']
  OPEN_STATES    = ['open', 'pending shipment', 'shipped']
  CLOSED_STATES  = ['canceled', 'completed']
  STATUS_CLASSES = {
    :open => 'label-info',
    :pending_shipment => 'label-warning',
    :canceled => 'label-important',
    :shipped => 'label-inverse',
    :completed => 'label-success'
  }

  belongs_to :user
  belongs_to :store
  has_many :order_items, :dependent => :destroy

  scope :open, -> { where(:status => OPEN_STATES) }
  scope :closed, -> { where(:status => CLOSED_STATES) }
  scope :by_store_id, lambda { |store_id| where(:store_id => store_id)}

  validates :user, :store, :order_items, presence: true
  validates :order_items, presence: true, on: :update
  validates :status, inclusion: { in: VALID_STATES }

  monetize :total_cents
  monetize :shipping_cents
  monetize :application_fee_cents

  def total_items
    order_items.map(&:quantity).inject { |sum, n| sum + n }
  end

  def subtotal
    order_items.map(&:price).inject { |sum, n| sum + n }
  end

  def status_class
    STATUS_CLASSES[status.underscore.to_sym]
  end
end
