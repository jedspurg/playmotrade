class Country < ActiveRecord::Base
  has_many :users
  has_many :shipping_options, :dependent => :destroy
end
