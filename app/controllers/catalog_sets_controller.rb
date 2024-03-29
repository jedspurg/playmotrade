class CatalogSetsController < ApplicationController

  before_filter :catalog_set, :only => [:show, :edit, :update, :inventory]
  before_filter :store_inventory_set, :only => [:show]

  def index
    @catalog_sets = CatalogSet.paginate(:page => params[:page], :per_page => 24)
  end

  def show
    if user_signed_in?
      @wishlist      = Wishlist.find_or_create(:user_id => current_user.id, :name => "Main Wishlist")
      @wishlist_item = WishlistItem.new
    end
  end

  def edit
  end

  def update
    tags = Tag.find_or_create(params[:catalog_set][:tags])
    if @catalog_set.update_attributes(catalog_set_params.merge!(:tags => tags))
      flash[:notice] = "Catalog Set Updated"
      redirect_to catalog_set_path(@catalog_set)
    else
      flash[:error] = @catalog_set.errors.full_messages.to_sentence
      render :action => :edit
    end
  end

  def inventory
    @catalog_inventory     = @catalog_set.inventory
    @catalog_iventory_list = @catalog_inventory.try(:list)
  end

  protected ###################################################################

  def catalog_set
    @catalog_set        = CatalogSet.find(params[:id])
    @available_for_sale = @catalog_set.available_for_sale.paginate(:page => params[:page], :per_page => 24)
  end

  def store_inventory_set
    @store_inventory_set = StoreInventorySet.new
  end

  def catalog_set_params
    params.require(:catalog_set).permit(:name, :number, :image, :back_image, :theme, :part_count, :tags,
                                        :figure_count, :release_date, :retire_date, :dimensions, :weight)
  end

end
