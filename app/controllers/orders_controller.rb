class OrdersController < ApplicationController
  before_filter :setup_wishlists

  def index
    @store = Store.find_by(id: params[:store_id].to_i)
    @orders = if @store.present?
      current_user.orders.by_store_id(@store.id).open.paginate(:page => params[:page], :per_page => 24)
    else
      current_user.orders.open.paginate(:page => params[:page], :per_page => 24)
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private #####################################################################

  def setup_wishlists
    if user_signed_in?
      @wishlists = current_user.wishlists
      @wishlist  = if current_user.wishlists.blank?
        Wishlist.create(:user_id => current_user.id, :name => "Main Wishlist")
      else
        current_user.wishlists.first
      end
    else
      @wishlists = []
      @wishlist  = Wishlist.new
    end
  end

end
