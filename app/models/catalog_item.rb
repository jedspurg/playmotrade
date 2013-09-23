class CatalogItem < ActiveRecord::Base
  acts_as_superclass

  validates :name, :presence => true#, :uniqueness => true
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

  def self.dedupe
    # find all models and group them on keys which should be common
    grouped = all.group_by{|model| [model.name,model.number] }
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each{|double| double.destroy} # duplicates can now be destroyed
    end
  end

end
