class Tag < ActiveRecord::Base
  has_many :catalog_tags
  has_many :catalog_items, :through => :catalog_tags

  validates :name, :presence => true

  searchable do
    text :name
  end

  def self.find_or_create(list)
    tags = []
    tag_list = list.split(',').flatten
    tag_list.each do |item|
      tag = Tag.find_by(:name => item.strip) || Tag.create({:name => item.strip})
      tags << tag if tag.present?
    end if list.present?
    tags
  end
end