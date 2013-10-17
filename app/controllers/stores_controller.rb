class StoresController < ApplicationController

  before_filter :find_store_by_name_or_id, :only => [:edit, :show, :update, :destroy, :store_closed, :break_in, :inventory, :search]
  before_filter :check_if_store_closed, :only => [:show]

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
      flash[:error] = @store.errors.full_messages
      render :action => :new
    end
  end

  def update
    if @store.update_attributes(store_params)
      flash[:notice] = "Store Updated"
      redirect_to root_url(:subdomain => @store.alias)
    else
      flash[:error] = @store.errors.full_messages
      render :action => :edit
    end
  end

  def destroy
    @store.destroy
    flash[:notice] = "Store Deleted"
    redirect_to stores_path
  end

  def store_closed
  end

  def break_in
    if params[:break_in_password] == @store.bypass_password
      session["#{@store.alias}_break_in"] = true
      redirect_to root_url(:subdomain => @store.alias)
    else
      flash[:error] = "Break in password is incorrect"
      render :action => :store_closed
    end
  end

  def inventory
    @type = params[:type].to_sym
    case @type
    when :parts
      @store_inventory = @store.store_inventory.store_inventory_parts.paginate(:page => params[:page], :per_page => 30)
    when :sets
      @store_inventory = @store.store_inventory.store_inventory_sets.paginate(:page => params[:page], :per_page => 30)
    end
  end

  def add_part_to_inventory
    @store = current_user.store
    @store_inventory_part = StoreInventoryPart.new(store_inventory_part_params.merge!({
      :store_inventory => @store.store_inventory,
      :catalog_part    => CatalogPart.find(params[:id])
    }))
    if @store_inventory_part.save
      flash[:notice] = "Part added to inventory"
      redirect_to root_url(:subdomain => @store.alias)
    else
      flash[:error] = @store_inventory_part.errors.full_messages
      redirect_to root_url(:subdomain => @store.alias)
    end
  end

  def search
    @type        = params[:type].to_sym
    inventory_id = @store.store_inventory.id

    case @type
    when :parts
      @store_inventory = StoreInventoryPart.search do
        fulltext "#{params[:q]}*" do
          boost_fields :name => 2.0
        end
        with(:store_inventory_id).equal_to(inventory_id)
        paginate :page => params[:page], :per_page => 24
      end.results
    when :sets
      @store_inventory = StoreInventorySet.search do
        fulltext "#{params[:q]}*" do
          boost_fields :name => 2.0
        end
        with(:store_inventory_id).equal_to(inventory_id)
        paginate :page => params[:page], :per_page => 24
      end.results
    else
      @type = "all"
      @store_inventory = Sunspot.search(StoreInventoryPart,StoreInventorySet) do
        fulltext "#{params[:q]}*" do
          boost_fields :name => 2.0
        end
        with(:store_inventory_id).equal_to(inventory_id)
        paginate :page => params[:page], :per_page => 24
      end.results
    end
  end

  protected ###################################################################

  def find_store_by_name_or_id
    if request.subdomain.present?
      @store = Store.find_by(:alias => request.subdomain)
    else
      @store = Store.find(params[:id])
    end
  end

  def check_if_store_closed
    if @store.active != true && current_user != @store.user && session["#{@store.alias}_break_in"] != true
      render :action => :store_closed
    end
  end

  def store_params
    params.require(:store).permit(:name, :alias, :logo, :about, :landing_page, :active, :bypass_password, :closed_message)
  end

  def store_inventory_part_params
    params.require(:store_inventory_part).permit(:quantity, :price, :condition, :comment)
  end

end
