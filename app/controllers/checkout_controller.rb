class CheckoutController < ApplicationController
  before_filter :setup_cart

  def new
    redirect_to root_url(:subdomain => nil) if @cart.blank?
  end

  def create
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount      => 10020, # amount in cents, again
        :currency    => "usd",
        :card        => token,
        :description => "payinguser@example.com"
      )
    rescue Stripe::CardError => e
      flash[:error] = e.message
      render :new
    end
  end

  private #####################################################################

  def setup_cart
    @cart = Cart.find(params[:cart_id])
  end
end
