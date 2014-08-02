class ShippingOptionsController < ApplicationController
  before_filter :find_store

  def index
    @shipping_options = @store.shipping_options.paginate(:page => params[:page], :per_page => 24)
  end

  def edit
    @shipping_option = ShippingOption.find(params[:id])
    setup_available_countries
  end

  def new
    setup_available_countries
    @shipping_option = @store.shipping_options.new
  end

  def show
    redirect_to store_shipping_options_path(@store)
  end

  def create
    @shipping_option = @store.shipping_options.new(shipping_option_params)
    if @shipping_option.save
      flash[:notice] = "Shipping Option Created"
      redirect_to store_shipping_options_path(@store)
    else
      setup_available_countries
      render :action => :new
    end
  end

  def update
    @shipping_option = ShippingOption.find(params[:id])
    if @shipping_option.update_attributes(shipping_option_params)
      flash[:notice] = "Shipping Option Updated"
      redirect_to store_shipping_options_path(@store)
    else
      setup_available_countries
      render :action => :edit
    end
  end

  def destroy
    @shipping_option = ShippingOption.find(params[:id])
    @shipping_option.destroy
    flash[:notice] = "Shipping Option Deleted"
    redirect_to store_shipping_options_path(@store)
  end

  private #####################################################################

  def shipping_option_params
    params.require(:shipping_option).permit(:country_id, :tax, :base_price, :base_price_currency, :per_gram_price, :per_gram_price_currency, :option)
  end

  def find_store
    @store = Store.find_by(id: params[:store_id])
  end

  def setup_available_countries
    @available_countries = (Country.all - @store.shipping_options.map(&:country))
    @available_countries << @shipping_option.country if @shipping_option.present?
  end

end
