class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, :presence => true, :uniqueness => true
  validates :agrees_to_tos, acceptance: true

  has_attached_file :avatar, :styles => {:medium => "250x250>",
  				                               :thumb => "100x100>",
                                         :small => "20x20>" }, 
                              :default_url => "/images/:style/missing.png"

  scope :active, -> { where(:active => true) }
end