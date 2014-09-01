class Store < ActiveRecord::Base

  after_save :find_or_build_store_inventory
  before_save :domainize_alias

  belongs_to :user
  has_one :store_inventory, :dependent => :destroy
  has_many :orders
  has_many :pages, -> { order("position ASC") }, through: :user
  has_many :shipping_options, :dependent => :destroy
  validates :name, :presence => true, :uniqueness => true
  validates :user_id, :presence => true, :uniqueness => true
  validates :alias, :presence => true, :uniqueness => true
  validates_exclusion_of :alias, in: ['www', 'mail', 'ftp'], message: "is not available"

  has_attached_file :logo, :styles => {:large => "250x250>",
                                       :medium => "100x100>",
                                       :thumb => "40x40!",
                                       :small => "20x20!" },
                           :default_url => "/images/stores/:style/missing.png"

  default_scope { order('name ASC') }
  scope :active, -> { where(:active => true) }

  def inventory
    StoreInventory.find_by(:store_id => id)
  end

  def payment_compliant?
    stripe_access_token.present? && stripe_publishable_key.present?
  end

  def shipping_available_for_cart?(cart)
    shipping_options.where(country: cart.user.country).present?
  end

  def calculate_shipping(cart)
    shipping_option = shipping_options.where(country: cart.user.country).take
    shipping_option.calculate_shipping(cart) if shipping_option.present?
  end

  def shipping_type_for(cart)
    shipping_option = shipping_options.where(country: cart.user.country).take
    shipping_option.type if shipping_option.present?
  end

  protected ###################################################################

  # before_save
  def domainize_alias
    self.alias = self.alias.downcase.gsub(" ", "-")
  end

  # after_save
  def find_or_build_store_inventory
    store_inventory = StoreInventory.find_or_create_by(:store_id => id)
  end


end
