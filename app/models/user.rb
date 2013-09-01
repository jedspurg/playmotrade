class User < ActiveRecord::Base
  validates :email, :presence => true, :uniqueness => true
  validates :username, :presence => true, :uniqueness => true
  validates :password, :presence => true,
                    :length => { :minimum => 5, :maximum => 40 },
                    :confirmation =>true
  validates :agrees_to_tos, :presence => true
  scope :active, -> { where(:active => true) }
end