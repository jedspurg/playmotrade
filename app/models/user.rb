class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :registerable, :confirmable
  validates :username, :presence => true, :uniqueness => true
  validates :agrees_to_tos, :acceptance => {:accept => true}

  has_attached_file :avatar, :styles => {:medium => "250x250>",
  				                               :thumb => "100x100!",
                                         :small => "20x20!" },
                              :default_url => "/images/:style/missing.png"
  has_one :store
  has_many :carts
  has_many :orders
  has_many :wishlists
  has_many :messages

  belongs_to :country

  scope :active, -> { where(['confirmed_at IS NOT NULL']) }

  VAILD_ROLES = ['admin', 'catalog_admin']

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    role == 'admin'
  end

  def catalog_admin?
    role == 'catalog_admin'
  end

  def received_messages
    Message.inbox.where(recipient_id: self.id)
  end

  # This will eventually be a user attribute
  def receive_email?
    true
  end

end
