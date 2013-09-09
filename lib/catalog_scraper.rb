class CatalogScraper

  attr_accessor :catalog_set_item

  def initialize(number)
    page = "http://collectobil.com/catalogue/items/#{number}.htm"
    begin
      doc = Nokogiri::HTML(open(page))

      @catalog_set_item = {}.tap do |item|
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
    rescue OpenURI::HTTPError
    end

  end

end
