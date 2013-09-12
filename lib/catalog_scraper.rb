class CatalogScraper
  require 'nokogiri'

  attr_accessor :catalog_set_item

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

  def playmodb_parts_list
    @range.each do |number|

      page = "http://playmodb.org/cgi-bin/listinv.pl?setnum=#{number}"
      begin
        doc = Nokogiri::HTML(open(page))

        parts_list = doc.at('pre')

      rescue OpenURI::HTTPError
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

end
