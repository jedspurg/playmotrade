class Message < ActiveRecord::Base

  after_create :send_email

  DISPOSITIONS = [
    SYSTEM                = 'system',
    PRIVATE               = 'private',
    NEW_ORDER             = 'new order',
    ORDER_SHIPPED         = 'order shipped',
    ORDER_QUESTION        = 'order question',
    WISHLIST_NOTIFICATION = 'wishlist notification'
  ]

  ORDER_DISPOSITIONS = [
    NEW_ORDER,
    ORDER_SHIPPED,
    ORDER_QUESTION
  ]

  belongs_to :user
  belongs_to :recipient, class_name: 'User'
  belongs_to :order
  belongs_to :parent_message, class_name: 'Message'

  validates :subject, :body, :user, :recipient, :disposition, presence: true
  validates :disposition, inclusion: { in: DISPOSITIONS }
  validates :order, presence: true, if: :order_disposition?

  scope :private, -> { where(disposition: PRIVATE) }
  scope :system, -> { where(disposition: SYSTEM) }
  scope :wishlist, -> { where(disposition: WISHLIST_NOTIFICATION) }
  scope :archived, -> { where(archive: true) }
  scope :inbox, -> { where(archive: false) }
  default_scope { order(created_at: :desc) }

  def order_disposition?
    ORDER_DISPOSITIONS.include?(disposition)
  end

  def child_messages
    messages.where(parent_message_id: id)
  end

  private #####################################################################

  def send_email
    if recipient.receive_email?
    end
  end

end
