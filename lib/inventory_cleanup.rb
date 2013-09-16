class InventoryCleanup

  def self.perform
    CatalogPart.find(35738).destroy
    CatalogPart.find(35739).destroy
    CatalogInventoryPart.where(:catalog_part_id => 35738).all.each do |part|
      part.destroy
    end
    CatalogInventoryPart.where(:catalog_part_id => 35739).all.each do |part|
      part.destroy
    end
  end

end