class StoresController < ApplicationController

  before_filter :find_store_by_name_or_id, :only => [:edit, :show, :update, :destroy]

  def index
    @stores = Store.active.paginate(:page => params[:page], :per_page => 30)
  end

  def edit
  end

  def new
    @store = Store.new
  end

  def show
    redirect_to models_path
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      flash[:notice] = "Store Created!"
      redirect_to store_path(@store)
    else
      render :action => :new
    end
  end

  def update
    if @store.update_attributes(params[:store])
      flash[:notice] = "Store Updated"
      redirect_to store_path(@store)
    else
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

end
