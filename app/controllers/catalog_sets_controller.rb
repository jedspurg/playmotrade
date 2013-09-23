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
    tags = Tag.find_or_create(params[:catalog_set][:tags])
    if @catalog_set.update_attributes(catalog_set_params.merge!(:tags => tags))
      flash[:notice] = "Catalog Set Updated"
      redirect_to catalog_set_path(@catalog_set)
    else
      render :action => :edit
    end
  end

  def inventory
    @catalog_inventory     = @catalog_set.inventory
    @catalog_iventory_list = @catalog_inventory.try(:list)
  end

  protected ###################################################################

  def catalog_set
    @catalog_set = CatalogSet.find(params[:id])
  end


  def catalog_set_params
    params.require(:catalog_set).permit(:name, :number, :image, :back_image, :theme, :part_count, :tags,
                                        :figure_count, :release_date, :retire_date, :dimensions, :weight)
  end

end
