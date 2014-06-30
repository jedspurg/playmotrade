class StoresController < ApplicationController

  before_filter :find_store_by_name_or_id, :except => [:index, :new, :create]
  before_filter :check_if_store_closed, :only => [:show]
  before_filter :find_or_build_user_cart_for_store, :only => [:show, :inventory, :add_items_to_cart, :cart]
  before_filter :check_cart_items_availability, :only => [:show, :inventory, :add_items_to_cart, :cart]
  before_filter :reload_cart, :only => [:show, :inventory, :add_items_to_cart, :cart]
  before_filter :setup_wishlists, :except => [:index, :new, :create]

  def index
    @stores = Store.paginate(:page => params[:page], :per_page => 30)
  end

  def edit
  end

  def new
    @store = Store.new
  end

  def show
    @user_owned = (current_user == @store.user)
  end

  def create
    @store = Store.new(store_params.merge!(:user => current_user))
    if @store.save
      flash[:notice] = "Store Created"
      redirect_to root_url(:subdomain => @store.alias)
    else
      flash[:error] = @store.errors.full_messages.to_sentence
      render :action => :new
    end
  end

  def update
    if @store.update_attributes(store_params)
      flash[:notice] = "Store Updated"
      redirect_to root_url(:subdomain => @store.alias)
    else
      flash[:error] = @store.errors.full_messages.to_sentence
      render :action => :edit
    end
  end

  def destroy
    @store.destroy
    flash[:notice] = "Store Deleted"
    redirect_to stores_path
  end

  def cart
  end

  def store_closed
  end

  def break_in
    if params[:break_in_password] == @store.bypass_password
      session[:store_break_in] = Digest::MD5.hexdigest(@store.alias)
      render :action => :show
    else
      flash[:error] = "Break in password is incorrect"
      render :action => :store_closed
    end
  end

  def inventory
    @cart_item = CartItem.new
    @type      = (params[:type].present? ? params[:type].to_sym : :all)
    case @type
    when :parts
      @store_inventory = @store.store_inventory.store_inventory_parts.active.paginate(:page => params[:page], :per_page => 30)
    when :sets
      @store_inventory = @store.store_inventory.store_inventory_sets.active.paginate(:page => params[:page], :per_page => 30)
    else
      @store_inventory = @store.store_inventory.all_items.paginate(:page => params[:page], :per_page => 30)
    end
  end

  def wishlist
    @cart_item     = CartItem.new
    @type          = (params[:type].present? ? params[:type].to_sym : :all)
    wishlist_parts = @store.store_inventory.store_inventory_parts.active.where(catalog_part_id: @wishlist.parts.pluck(:catalog_item_id))
    wishlist_sets  = @store.store_inventory.store_inventory_sets.active.where(catalog_set_id: @wishlist.sets.pluck(:catalog_item_id))
    @store_inventory = case @type
    when :parts
      wishlist_parts.paginate(:page => params[:page], :per_page => 30)
    when :sets
      wishlist_sets.paginate(:page => params[:page], :per_page => 30)
    else
      (wishlist_parts + wishlist_sets).paginate(:page => params[:page], :per_page => 30)
    end
  end

  def add_part_to_inventory
    @store_inventory_part = StoreInventoryPart.new(store_inventory_part_params.merge!({
      :store_inventory => @store.store_inventory,
      :catalog_part    => CatalogPart.find(params[:part_id])
    }))
    if @store_inventory_part.save
      flash[:notice] = "Part added to inventory"
      redirect_to root_url(:subdomain => @store.alias)
    else
      flash[:error] = @store_inventory_part.errors.full_messages.to_sentence
      redirect_to root_url(:subdomain => @store.alias)
    end
  end

  def add_set_to_inventory
    @store_inventory_set = StoreInventorySet.new(store_inventory_set_params.merge!({
      :store_inventory => @store.store_inventory,
      :catalog_set     => CatalogSet.find(params[:set_id])
    }))
    if @store_inventory_set.save
      flash[:notice] = "Set added to inventory"
      redirect_to root_url(:subdomain => @store.alias)
    else
      flash[:error] = @store_inventory_set.errors.full_messages.to_sentence
      redirect_to root_url(:subdomain => @store.alias)
    end
  end

  def search
    @cart_item   = CartItem.new
    @type        = (params[:type].present? ? params[:type].to_sym : :all)
    inventory_id = @store.store_inventory.id

    case @type
    when :part
      @store_inventory = Sunspot.search(StoreInventoryPart) do
        fulltext "#{params[:q]}*" do
          boost_fields :name => 2.0
        end
        with(:store_inventory_id).equal_to(inventory_id)
        paginate :page => params[:page], :per_page => 24
      end.results
    when :set
      @store_inventory = Sunspot.search(StoreInventorySet) do
        fulltext "#{params[:q]}*" do
          boost_fields :name => 2.0
        end
        with(:store_inventory_id).equal_to(inventory_id)
        paginate :page => params[:page], :per_page => 24
      end.results
    else
      @store_inventory = Sunspot.search(StoreInventoryPart,StoreInventorySet) do
        fulltext "#{params[:q]}*" do
          boost_fields :name => 2.0
        end
        with(:store_inventory_id).equal_to(inventory_id)
        paginate :page => params[:page], :per_page => 24
      end.results
    end
  end

  def add_items_to_cart
    if user_signed_in?
      session[:return_to] ||= request.referer
      if @cart.save
        @cart_item = CartItem.find_or_initialize_by_store_inventory_item_id_and_store_inventory_item_type(cart_item_params)
        @cart_item.update_attributes(cart_item_params.merge!(:cart => @cart))
      end
      if @cart_item.save
        flash[:notice] = "Items added to cart."
        redirect_to cart_store_path(@store)
      else
        flash[:error] = @cart_item.errors.full_messages.to_sentence
        redirect_to session.delete(:return_to)
      end
    else
      flash[:error] = "You must be logged in to add items to a cart."
      redirect_to root_url(:subdomain => @store.alias)
    end
  end

  def remove_items_from_cart
    @cart_item = CartItem.find_by(:id => params[:item_id])
    if @cart_item.destroy
      flash[:notice] = "Items removed from cart."
    else
      flash[:error] = @cart_item.errors.full_messages.to_sentence
    end
    redirect_to cart_store_path(@store)
  end

  protected ###################################################################

  def setup_wishlists
    if user_signed_in?
      @wishlists = current_user.wishlists
      @wishlist  = if params[:wishlist_id].present?
        current_user.wishlists.find(params[:wishlist_id])
      elsif current_user.wishlists.blank?
        Wishlist.create(:user_id => current_user.id, :name => "Main Wishlist")
      else
        current_user.wishlists.first
      end
    else
      @wishlists = []
      @wishlist  = Wishlist.new
    end
  end

  def find_store_by_name_or_id
    if request.subdomain.present?
      @store = Store.find_by(:alias => request.subdomain)
    else
      @store = Store.find(params[:id])
    end
  end

  def find_or_build_user_cart_for_store
    if user_signed_in?
      @cart = Cart.find_or_create_by_store_id_and_user_id_and_checked_out({
        :store_id => @store.id,
        :user_id => current_user.id,
        :checked_out => false
      })
    else
      @cart = Cart.new
    end
  end

  def reload_cart
    @cart.reload if !@cart.new_record?
  end

  def check_if_store_closed
    if @store.active != true && current_user != @store.user && session[:store_break_in] != Digest::MD5.hexdigest(@store.alias)
      render :action => :store_closed
    end
  end

  def check_cart_items_availability
    @cart.check_item_availability
    flash[:error] = @cart.errors.full_messages.to_sentence
  end

  def store_params
    params.require(:store).permit(:name, :alias, :logo, :about, :landing_page, :active, :bypass_password, :closed_message)
  end

  def store_inventory_part_params
    params.require(:store_inventory_part).permit(:quantity, :price, :condition, :comment)
  end

  def store_inventory_set_params
    params.require(:store_inventory_set).permit(:quantity, :price, :condition, :comment)
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity, :store_inventory_item_id, :store_inventory_item_type)
  end

end
