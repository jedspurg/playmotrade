class BuildInventories < ActiveRecord::Migration

  def self.perform
    CatalogSet.all.each do |set|
      if set.playmodb_inventory.present?
        inventory_array = set.playmodb_inventory.strip.split(/\n/)

        inventory_hash = {}
        inventory_array.each_with_index do |row, index|
          r       = row.split(/\t/)
          row_num = "row#{index}".to_sym
          part_info = {}.tap do |pi|
            pi[:part_number]   = r[0].to_s.strip
            pi[:part_quantity] = r[1].to_s.strip
            pi[:part_name]     = r[2].to_s.strip
          end
          inventory_hash[row_num] = part_info
        end

        if inventory_hash.count > 2
          catalog_inventory = CatalogInventory.create!({
            :catalog_set_id => set.id
          })
          inventory_hash.each do |part_row|
            catalog_item = CatalogItem.find_by(:number => part_row[1][:part_number])
            catalog_part = CatalogPart.find_by(:id => catalog_item.try(:catalogable_id))

            if catalog_part.blank?
              number = part_row[1][:part_number]
              name   = part_row[1][:part_name]

              if name.present? && number.present?
                catalog_part = CatalogPart.create({
                  :number => number,
                  :name => name
                })
              end
            end
            quantity = part_row[1][:part_quantity].strip.gsub('x', '').to_i rescue 0
            if catalog_part.present?
              CatalogInventoryPart.create({
                :catalog_inventory_id => catalog_inventory.id,
                :catalog_part_id      => catalog_part.id,
                :quantity             => quantity

              })
            end

          end

        end
      end
    end
  end

end
