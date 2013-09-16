class CatalogPartsController < ApplicationController

  def index
    @catalog_parts = CatalogPart.all.paginate(:page => params[:page], :per_page => 24)
  end

  def show
    @catalog_part = CatalogPart.find(params[:id])
  end

end