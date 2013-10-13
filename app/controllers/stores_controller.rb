class StoresController < ApplicationController

  before_filter :find_store_by_name_or_id, :only => [:edit, :show, :update, :destroy]

  def index
    @stores = Store.paginate(:page => params[:page], :per_page => 30)
  end

  def edit
  end

  def new
    @store = Store.new
  end

  def show
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

  protected ###################################################################

  def find_store_by_name_or_id
    if request.subdomain.present?
      @store = Store.find_by(:alias => request.subdomain)
    else
      @store = Store.find(params[:id])
    end
  end

  def store_params
    params.require(:store).permit(:name, :alias, :logo, :about, :landing_page, :active)
  end

end
