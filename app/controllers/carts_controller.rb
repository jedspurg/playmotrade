class CartsController < ApplicationController

  def index
    if user_signed_in?
      @carts = current_user.carts.open.not_empty.paginate(:page => params[:page], :per_page => 30)
      @carts.map(&:check_item_availability)
    end
  end

  def destroy
    @cart = Cart.find(params[:id])
    if @cart.destroy
      flash[:notice] = "Cart Deleted"
      redirect_to carts_path
    else
      flash[:error] = "There was an error deleting this cart"
      redirect_to carts_path
    end
  end

end
