class CatalogSetsController < ApplicationController

  before_filter :catalog_set, :only => [:show, :edit, :update, :inventory]

  def index
    @catalog_sets = CatalogSet.paginate(:page => params[:page], :per_page => 24)
  end

  def show
  end

  def edit
  end

  def update
    if @catalog_set.update_attributes(catalog_set_params)
      flash[:notice] = "Catalog Set"
      redirect_to catalog_set_path(@catalog_set)
    else
      render :action => :edit
    end
  end

  def inventory
    @catalog_iventory_list = @catalog_set.inventory.list
  end

  protected ###################################################################

  def catalog_set
    @catalog_set = CatalogSet.find(params[:id])
  end


  def catalog_set_params
    params.require(:catalog_set).permit(:name, :number, :image, :back_image, :theme, :part_count, :figure_count, :release_date, :retire_date, :dimensions, :weight)
  end

end