class CatalogPartsController < ApplicationController

  before_filter :catalog_part, :only => [:show, :edit, :update, :inventory]
  before_filter :store_inventory_part, :only => [:show]

  def index
    @catalog_parts = CatalogPart.all.paginate(:page => params[:page], :per_page => 24)
  end

  def show
  end

  def edit
  end

  def update
    tags = Tag.find_or_create(params[:catalog_part][:tags])
    if @catalog_part.update_attributes(catalog_part_params.merge!(:tags => tags))
      flash[:notice] = "Catalog Part Updated"
      redirect_to catalog_part_path(@catalog_part)
    else
      render :action => :edit
    end
  end

  protected ###################################################################

  def catalog_part
    @catalog_part = CatalogPart.find(params[:id])
  end

  def store_inventory_part
    @store_inventory_part = StoreInventoryPart.new
  end

  def catalog_part_params
    params.require(:catalog_part).permit(:name, :number, :image, :color, :catalog_parts_category_id,
                                         :catalog_parts_subcategory_id, :tags)
  end

end
