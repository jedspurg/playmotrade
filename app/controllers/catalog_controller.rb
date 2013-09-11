class CatalogController < ApplicationController

  def index
    @catalog_items = CatalogItem.all.paginate(:page => params[:page], :per_page => 24)
  end

end