class CatalogSetsController < ApplicationController

  before_filter :catalog_set, :only => [:show, :inventory]

  def index
    @catalog_items = CatalogSet.paginate(:page => params[:page], :per_page => 24)
  end

  def show
  end

  def inventory
    @catalog_iventory_list = @catalog_set.inventory.list
  end

  protected ###################################################################

  def catalog_set
    @catalog_set = CatalogSet.find(params[:id])
  end

end