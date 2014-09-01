class CheckoutController < ApplicationController
  before_filter :setup_cart

  def new
    if @cart.blank?
      flash[:error] = "Cannot checkout without a cart."
      redirect_to carts_path
      return
    end

    if @cart.store.stripe_publishable_key.blank?
      flash[:warning] = "This store is not set up for payment processing."
      redirect_to cart_store_path(@cart.store)
      return
    end

    if @cart.store.shipping_available_for_cart?(@cart)
      flash[:warning] = "This store does not ship to your country."
      redirect_to cart_store_path(@cart.store)
      return
    end

    @shipping = @cart.store.calculate_shipping(@cart)
  end

  def create
    token = params[:stripeToken]

    begin
      create_order!
      # Not sure why we don't have current_user in create.....
      current_user = @cart.user
      if current_user.stripe_id.blank?
        current_user.update_column(:stripe_id, token)
      end
      charge = Stripe::Charge.create(
        {
          :amount          => @order.total.cents,
          :currency        => @order.total.currency.to_s.downcase,
          :card            => token,
          :description     => "Playmotrade Order ##{@order.id} - #{@cart.store.name}",
          :application_fee => @order.application_fee.cents
        },
        Base64.decode64(@cart.store.stripe_access_token)
      )
      update_store_inventory!

      # empty the current cart....
      @cart = nil

    rescue Stripe::CardError, Stripe::InvalidRequestError => e
      @order.destroy
      flash[:error] = e.message
      render :new
    end
  end

  private #####################################################################

  def setup_cart
    @cart = Cart.find(params[:cart_id])
  end

  def create_order!
    ActiveRecord::Base.transaction do
      store           = @cart.store
      shipping_total  = store.calculate_shipping(@cart)
      order_total     = @cart.total_cost + shipping_total
      @order = Order.create({
        user:            @cart.user,
        store:           store,
        shipping:        shipping_total,
        total:           order_total,
        application_fee: (order_total * APPLICATION_FEE_PERCENTAGE),
        status:          'pending shipment'
      })
      @cart.cart_items.each do |item|
        @order.order_items.build({
          quantity:                item.quantity,
          price:                   item.price,
          store_inventory_item_id: item.store_inventory_item_id,
          catalog_item_id:         item.associated_object.catalog_item_id,
          catalog_item_type:       item.associated_object.catalog_item_type,
          store_id:                store.id
        })
      end
      @order.save!
    end
  end

  def update_store_inventory!
    @cart.cart_items.each do |item|
      item.update_store_inventory_item!
    end
    @cart.update_attributes!(checked_out: true)
  end
end
