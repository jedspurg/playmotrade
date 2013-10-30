class CartsController < ApplicationController

  def index
    if user_signed_in?
      @carts = current_user.carts.open.paginate(:page => params[:page], :per_page => 30)
      @carts.all.map(&:check_item_availability)
    end
  end

end
