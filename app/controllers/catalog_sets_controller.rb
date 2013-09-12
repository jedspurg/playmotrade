class CatalogSetsController < ApplicationController

  def index
    @catalog_items = CatalogItem.sets.paginate(:page => params[:page], :per_page => 24)
  end

  def show
    catalog_item = CatalogItem.find(params[:id])
    @catalog_set = CatalogSet.find_by(:id => catalog_item.catalogable_id)
  end

end