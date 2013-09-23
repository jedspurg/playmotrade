class InventoryCleanup

  def self.perform
    CatalogPart.find(35740).destroy
    CatalogInventoryPart.where(:catalog_part_id => 35740).each do |part|
      part.destroy
    end
  end

  def self.remove_invalid_parts
    parts = CatalogPart.select{|p| p.number.length > 10 }
    parts.each do |part|
      part.destroy
    end
  end

  def self.find_missing_parts_images(format="gif")
    Dir.entries("/Users/jeramy/parts_images/").each do |file|
      part_number = file.gsub(".#{format}", "")
      if part_number.length == 9
        part_number = "#{part_number}0"
      end
      ci = CatalogItem.find_by(:number => part_number)
      if ci.present? && ci.image.blank?
        ci.update_attributes({
          :image => open("/Users/jeramy/parts_images/#{file}")
          })
      else
        puts "File #{file} found but no Catalog Part could be matched"
      end
    end
  end

  def self.find_missing_set_images(format="jpg")
    Dir.entries("/Users/jeramy/Dropbox/SiteOrchard/playmotrade/set_images/").each do |file|
      part_number = file.gsub(".#{format}", "")
      ci = CatalogItem.find_by(:number => part_number)
      if ci.present? && ci.image.blank?
        ci.update_attributes({
          :image => open("/Users/jeramy/Dropbox/SiteOrchard/playmotrade/set_images/#{file}")
          })
      else
        puts "File #{file} found but no Catalog Part could be matched"
      end
    end
  end

  def self.remove_bad_images
    CatalogItem.where(["image_file_name = ?", "stringio.txt"]).each do |item|
      item.image = nil
      item.save!
    end
  end

end
