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
  belongs_to :country

  scope :active, -> { where(['confirmed_at IS NOT NULL']) }
end
