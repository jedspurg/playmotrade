class CatalogPartsController < ApplicationController

  def index
    @catalog_parts = CatalogItem.parts.paginate(:page => params[:page], :per_page => 24)
  end

  def show
    catalog_item = CatalogItem.find(params[:id])
    @catalog_part = CatalogPart.find_by(:id => catalog_item.catalogable_id)
  end

end