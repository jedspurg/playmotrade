class CatalogItem < ActiveRecord::Base
  acts_as_superclass

  validates :name, :presence => true
  validates :number, :presence => true, :uniqueness => true

  has_attached_file :image, :styles => {
                                          :large  => "500x500>",
                                          :medium => "250x250>",
                                          :thumb  => "100x100>",
                                          :small  => "70x70>",
                                          :tiny  => "30x30>"
                                        }, :default_url => "/images/items/:style/missing.png"

  has_many :catalog_tags
  has_many :tags, :through => :catalog_tags

  accepts_nested_attributes_for :tags

  default_scope{ order('number ASC') }

  scope :sets, -> { where(:catalogable_type => "CatalogSet") }
  scope :parts, -> { where(:catalogable_type => "CatalogPart") }

  searchable do
    text :name, :number, :catalogable_type
    text :tags do
      tags.map{ |tag| tag.name }
    end
  end

end
