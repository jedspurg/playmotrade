class OrdersController < ApplicationController

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

end
