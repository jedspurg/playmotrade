class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, :presence => true, :uniqueness => true
  validates :agrees_to_tos, acceptance: true, :message => "You must accept the terms of service."

  attr_accessible :avatar
  has_attached_file :avatar, :styles => {:medium => "250x250>",
  				                               :thumb => "100x100>",
                                         :small => "20x20>" }, 
                              :default_url => "/images/:style/missing.png"

  scope :active, -> { where(:active => true) }
end