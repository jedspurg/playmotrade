class CatalogScraper
  require 'nokogiri'

  attr_accessor :catalog_set_item

  PLAYMODB_PART_CATEGORIES = ["123-Animal", "123-Building", "123-Klicky", "123-Object", "123-Plant", "123-Vehicle", "Animal-%3F", 
    "Animal-Bird", "Animal-Coldblooded", "Animal-Invertebrate", "Animal-Mammal,Domestic", "Animal-Mammal,Wild", "Building-", 
    "Building-Bridge", "Building-Castle", "Building-Circus%20ring", "Building-Cloth", "Building-Decoration", "Building-Egyptian", 
    "Building-Fairytale%20Castle", "Building-Indian", "Building-Machinery", "Building-Medieval%20house", "Building-Minifort", 
    "Building-Roman", "Building-Space", "Building-Space%20System%20X", "Building-System%20X", "Building-System%20X%20Castle", 
    "Building-System%20X%20Horizontal", "Building-System%20X%20Vertical", "Building-Victorian", "Building-Western", "Building-Woodframe", 
    "Cloth-", "Cloth-Decoration", "Cloth-Floor", "Cloth-Household", "Cloth-Sail", "Cloth-String", "Decoration-", "Decoration-Feather", 
    "Decoration-Flag", "Decoration-Sign", "Furniture-", "Furniture-Commercial", "Furniture-Container", "Furniture-Container,Portable", 
    "Furniture-Decoration", "Furniture-Dishes", "Furniture-Electric", "Furniture-Food", "Furniture-Household", "Furniture-Light", 
    "Furniture-Literary", "Furniture-Machinery", "Furniture-Medical", "Furniture-Modern", "Furniture-Musical", "Furniture-Natural", 
    "Furniture-Office", "Furniture-Outdoor", "Furniture-Space", "Furniture-Storage", "Furniture-Toy", "Furniture-Treasure", 
    "Furniture-Urban", "Furniture-War%20machine", "Humanoid-", "Klicky-Adult%20female", "Klicky-Adult%20male", "Klicky-Baby", 
    "Klicky-Body%20Part", "Klicky-Female%20child", "Klicky-Male%20child", "Klicky-Rabbit%20adult", "Klicky-Rabbit%20child", "Micro-Animals", 
    "Micro-Box", "Micro-Buildings", "Micro-Figures", "Micro-Objects", "Micro-Scenery", "Micro-Vehicles", "Paper-", "Paper-Background", 
    "Paper-Catalogue", "Paper-Container", "Paper-Instructions", "Paper-Poster", "Paper-Stickers", "Paper-Stickers,%20Bonus", 
    "Paper-Storybook", "Plant-", "Plant-Flower", "Plant-Fungus", "Plant-Tree", "Scenery-", "Scenery-Ground", "Scenery-Railroad", 
    "Scenery-Rock", "Scenery-Urban", "Scenery-Water", "Support-", "Support-Electric", "Support-Electrical", "Support-Electronic", 
    "Support-Extra", "Support-Extras", "Support-Packaging", "Support-System%20X", "Support-Theatre", "TO%20BE%20ASSIGNED-", "Tool-", 
    "Tool-Container,Portable", "Tool-Electronic", "Tool-Food", "Tool-Light", "Tool-Literary", "Tool-Machinery", "Tool-Medical", 
    "Tool-Musical", "Tool-Shield", "Tool-Toy", "Tool-Weapon", "Vehicle-", "Vehicle-Aircraft", "Vehicle-Cargo", "Vehicle-Click%20and%20Go", 
    "Vehicle-Commercial", "Vehicle-Container", "Vehicle-Electrical", "Vehicle-Electronic", "Vehicle-Fantasy", "Vehicle-Heavy%20Equipment", 
    "Vehicle-Historical", "Vehicle-Large%20passenger", "Vehicle-Light", "Vehicle-Light%20Truck", "Vehicle-Machinery", "Vehicle-Modern", 
    "Vehicle-Passenger", "Vehicle-Personal", "Vehicle-Racing", "Vehicle-Riding", "Vehicle-Small%20Passenger", "Vehicle-Snow", 
    "Vehicle-Space", "Vehicle-Toy", "Vehicle-Trailer", "Vehicle-Train", "Vehicle-Victorian", "Vehicle-Watercraft", "Wearable-", 
    "Wearable-Accessories", "Wearable-Animal", "Wearable-Armwear", "Wearable-Beard", "Wearable-Bodywear", "Wearable-Cloaks", 
    "Wearable-Container", "Wearable-Decoration", "Wearable-Footwear", "Wearable-Hair", "Wearable-Headwear,Hard", 
    "Wearable-Headwear,Soft", "Wearable-Legwear", "Wearable-Machinery", "Wearable-Neckwear"]

  def initialize(range, mode)
    @range = range
    @mode  = mode
  end

  def perform
    send(@mode)
  end

  def collectobil
    @range.each do |number|

      page = "http://collectobil.com/catalogue/items/#{number}.htm"
      begin
        doc = Nokogiri::HTML(open(page))

        catalog_set_item = {}.tap do |item|
          item[:main_image] = "http://collectobil.com/images/items/#{number}.jpg"
          item[:back_image] = "http://collectobil.com/images/items/d#{number}.jpg"
          table = doc.at('table.catDEFAULT')

          keys = []
          data = []

          table.search('tr.catBLACK').each do |tr|
            tr.search('td').each do |td|
              keys << td.text.to_s.downcase.gsub(/ +/,'_').to_sym
            end
          end

          table.search('tr').each do |tr|
            next if (tr['class'] == 'catBLACK')
            tr.search('td').each do |td|
              next if (td['colspan'] == '5')
              data << td.text
            end
          end

          keys[0..-2].each_with_index do |key, index|
            item[key] = data[index]
          end
        end

        img     = open(URI.parse(catalog_set_item[:main_image])) rescue nil
        backimg = open(URI.parse(catalog_set_item[:back_image])) rescue nil

        existing_catalog_item = CatalogItem.find_by(:number => catalog_set_item[:item])
        if existing_catalog_item.present?
          catalog_set = CatalogSet.find_by(:id => existing_catalog_item.catalogable_id)
          catalog_set.update_attributes!({
            :image        => img,

            :name         => catalog_set_item[:international_name],
            :dimensions   => catalog_set_item[:dimensions],
            :weight       => catalog_set_item[:weight],
            :figure_count => catalog_set_item[:figures].to_i,
            :theme        => catalog_set_item[:theme],
            :release_date => catalog_set_item[:released].to_s.match('\d{4}').to_s.to_i
          })
        else
          CatalogSet.create!({
            :image        => img,
            :back_image   => backimg,
            :number       => catalog_set_item[:item],
            :figure_count => catalog_set_item[:figures].to_i,
            :name         => catalog_set_item[:international_name],
            :theme        => catalog_set_item[:theme],
            :dimensions   => catalog_set_item[:dimensions],
            :weight       => catalog_set_item[:weight],
            :release_date => catalog_set_item[:released].to_s.match('\d{4}').to_s.to_i
          })
        end

      rescue OpenURI::HTTPError
      end
      
    end
  end

  def collectobil_refresh
    @range.each do |number|
      existing_catalog_item = CatalogItem.find_by(:number => number.to_s)
      existing_image = existing_catalog_item.image rescue nil
      if existing_image.blank?
        page = "http://collectobil.com/catalogue/items/#{number}.htm"
        begin
          doc = Nokogiri::HTML(open(page))

          catalog_set_item = {}.tap do |item|
            item[:main_image] = "http://collectobil.com/images/items/#{number}.jpg"
            item[:back_image] = "http://collectobil.com/images/items/d#{number}.jpg"
            table = doc.at('table.catDEFAULT')

            keys = []
            data = []

            table.search('tr.catBLACK').each do |tr|
              tr.search('td').each do |td|
                keys << td.text.to_s.downcase.gsub(/ +/,'_').to_sym
              end
            end

            table.search('tr').each do |tr|
              next if (tr['class'] == 'catBLACK')
              tr.search('td').each do |td|
                next if (td['colspan'] == '5')
                data << td.text
              end
            end

            keys[0..-2].each_with_index do |key, index|
              item[key] = data[index]
            end
          end

          img     = open(URI.parse(catalog_set_item[:main_image])) rescue nil
          backimg = open(URI.parse(catalog_set_item[:back_image])) rescue nil

          existing_catalog_item = CatalogItem.find_by(:number => catalog_set_item[:item])
          if existing_catalog_item.present?
            catalog_set = CatalogSet.find_by(:id => existing_catalog_item.catalogable_id)
            catalog_set.update_attributes!({
              :image        => img,

              :name         => catalog_set_item[:international_name],
              :dimensions   => catalog_set_item[:dimensions],
              :weight       => catalog_set_item[:weight],
              :figure_count => catalog_set_item[:figures].to_i,
              :theme        => catalog_set_item[:theme],
              :release_date => catalog_set_item[:released].to_s.match('\d{4}').to_s.to_i
            })
          else
            CatalogSet.create!({
              :image        => img,
              :back_image   => backimg,
              :number       => catalog_set_item[:item],
              :figure_count => catalog_set_item[:figures].to_i,
              :name         => catalog_set_item[:international_name],
              :theme        => catalog_set_item[:theme],
              :dimensions   => catalog_set_item[:dimensions],
              :weight       => catalog_set_item[:weight],
              :release_date => catalog_set_item[:released].to_s.match('\d{4}').to_s.to_i
            })
          end

        rescue OpenURI::HTTPError
        end
      end
    end
  end

  def playmodb_set
    @range.each do |number|

      page = "http://playmodb.org/cgi-bin/listinv.pl?setnum=#{number}"
      begin
        doc = Nokogiri::HTML(open(page))

        name = doc.search('h2')[1].text.strip rescue nil
  
        if name.present? && CatalogItem.find_by(:number => number.to_s).blank?
          CatalogSet.create!({
            :number       => number.to_s,
            :name         => name
          })
        end

      rescue OpenURI::HTTPError
      end
      
    end
  end

  def playmodb_set_inventories
    @range.each do |number|

      page = "http://playmodb.org/cgi-bin/listinv.pl?setnum=#{number}"
      begin
        doc = Nokogiri::HTML(open(page))

        parts_list = doc.at('pre').text rescue nil

        existing_catalog_item = CatalogItem.find_by(:number => number.to_s)
        if existing_catalog_item.present? && parts_list.present?
          catalog_set = CatalogSet.find_by(:id => existing_catalog_item.catalogable_id)
          catalog_set.update_attributes!({
            :playmodb_inventory => parts_list
          })
        end

      rescue OpenURI::HTTPError
      end
      
    end
  end

  def playmodb_parts
    @range.each do |num|

      first_page = "http://playmodb.org/cgi-bin/category.pl?sortby=description&page=1&category=#{PLAYMODB_PART_CATEGORIES[num]}&pics=on"
      init_doc = Nokogiri::HTML(open(first_page))

      init_doc.search('p.pagination a').each_with_index do |obj, index|
        page_num = index + 1
        page     = "http://playmodb.org/cgi-bin/category.pl?sortby=description&page=#{page_num}&category=#{PLAYMODB_PART_CATEGORIES[num]}&pics=on"
        begin
          doc = Nokogiri::HTML(open(page))

          doc.search('div.lineup').each do |part|
            number = part.search('div.listpartnumber').text rescue nil
            name   = part.search('div.listpartname').text rescue nil
            #image  = open(URI.parse(part.search('img').last['src'])) rescue nil
            color  = part.search('small').text rescue nil

            if number == '(unknown part #)' || number.blank?
              number = rand.to_s.gsub('0.','p') 
            end

            category = PLAYMODB_PART_CATEGORIES[num]
            main_category = category.split('-').first.gsub('%20', ' ')
            main_category = 'Uncategorized' if main_category == ('TO BE ASSIGNED' || '%3F')
            sub_category  = category.split('-').last.gsub('%20', ' ') if category.split('-').count > 1

            catalog_parts_category    = CatalogPartsCategory.find_by(:name => main_category)
            catalog_parts_subcategory = CatalogPartsSubcategory.find_by(:name => sub_category)

            CatalogPart.create!({
                #:image                       => image,
                :name                         => name,
                :number                       => number,
                :color                        => color,
                :playmodb_category            => PLAYMODB_PART_CATEGORIES[num],
                :catalog_parts_subcategory_id => catalog_parts_subcategory.try(:id),
                :catalog_parts_category_id    => catalog_parts_category.try(:id)
              })
          end

        rescue OpenURI::HTTPError
        end
      end
      
    end
  end



  def playmobil
    @range.each do |number|

      page = "http://www.playmobil.us/on/demandware.store/Sites-US-Site/en_US/Product-Show?pid=#{number}"
      begin
        doc = Nokogiri::HTML(open(page))

        image = open(URI.parse("http://playmobil.scene7.com/is/image/Playmobil/#{number}_product_detail")) rescue nil
        name  = doc.at('h2.product-name').text rescue nil

        uri = URI.parse(doc.css('div.product-category-image a').first['href']) rescue nil
        theme = uri.query.gsub('categories=','').gsub('%2c', ' ').split(" ").last rescue nil

        if image.present? && name.present?
          existing_catalog_item = CatalogItem.find_by(:number => number.to_s)
          if existing_catalog_item.present?
            catalog_set = CatalogSet.find_by(:id => existing_catalog_item.catalogable_id)
            catalog_set.update_attributes!({
              :image        => image,
              :name         => name,
              :number       => number,
              :theme        => theme
            })
          else
            CatalogSet.create!({
              :image        => image,
              :name         => name,
              :number       => number,
              :theme        => theme
            })
          end
        end

      rescue OpenURI::HTTPError
      end
      
    end
  end

  def utoypia
    @range.each do |number|
      image = open(URI.parse("http://www.utoypia.com/images/bigplaymobil_#{number}.jpg")) rescue nil
      if image.present?
        existing_catalog_item = CatalogItem.find_by(:number => number.to_s)
        catalog_set = CatalogSet.find_by(:id => existing_catalog_item.catalogable_id)
        if catalog_set.image.blank?
          catalog_set.update_attributes!({
            :image => image
          })
        end
      end
    end
  end
    

end
