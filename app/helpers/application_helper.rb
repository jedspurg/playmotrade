module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Playmotrade"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def flash_class(level)
    case level
    when :notice then "info"
    when :error then "error"
    when :alert then "warning"
    end
  end

  def active_class(path_array)
    detected = path_array.select{|path| current_page?(path)}
    "current open" if detected.present?
  end

  def sub_active_class(path)
    "active" if current_page?(path)
  end

  def catalog_item_path(catalog_item)
    send("#{catalog_item.catalogable_type.underscore}_path", catalog_item.catalogable_id)
  end

  def catalog_item_url(catalog_item, options={})
    send("#{catalog_item.catalogable_type.underscore}_url", catalog_item.catalogable_id, options)
  end

  def footer_links(page_category_name, num_pages=3)
    Page.where('store_id IS NULL').by_page_category_name(page_category_name).limit(num_pages)
  end

  def instruction_link_exists?(catalog_set_number)
    url = URI.parse("http://playmobil.scene7.com/is/content/Playmobil/#{catalog_set_number}pdf.pdf")
    req = Net::HTTP.new(url.host, url.port)
    res = req.request_head(url.path)

    res.code == "200"
  end

end
