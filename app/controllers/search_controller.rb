class SearchController < ApplicationController

  def index
    @catalog_items = CatalogItem.search{fulltext params[:q]}.results
  end

end