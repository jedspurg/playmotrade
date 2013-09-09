class CatalogItem < ActiveRecord::Base
  acts_as_superclass

  validates :name, :presence => true
  validates :number, :presence => true, :uniqueness => true

  has_attached_file :image, :styles => { 
                                         :large  => "500x500>",
                                         :medium => "250x250>",
                                         :thumb  => "100x100>",
                                         :small  => "30x30>" 
                                        }, :default_url => "/images/items/:style/missing.png"
end