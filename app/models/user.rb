class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, :uniqueness => true

  scope :active, -> { where(:active => true) }
end