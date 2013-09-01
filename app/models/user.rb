class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, :presence => true, :uniqueness => true
  validates :agrees_to_tos, :presence => true
  scope :active, -> { where(:active => true) }
end