class WishlistsController < ApplicationController

  def index
    @wishlists = current_user.wishlists.paginate(:page => params[:page], :per_page => 10) if user_signed_in?
    @public_wishlists = Wishlist.public.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @wishlist       = Wishlist.find(params[:id])
    @wishlist_items = @wishlist.wishlist_items.paginate(:page => params[:page], :per_page => 30)
  end

  def add_item
    new_wishlist = Wishlist.find_or_create(user_id: current_user.id, name: params[:new_wishlist_name], public: params[:new_wishlist_public])
    if new_wishlist.valid?
      wishlist_item_params.delete(:wishlist)
      @wishlist_item = WishlistItem.new(wishlist_item_params.merge!(wishlist: new_wishlist))
    else
      @wishlist_item = WishlistItem.new(wishlist_item_params)
    end

    if @wishlist_item.save
      flash[:notice] = "Item added to wishlist: #{@wishlist_item.wishlist.name}"
    else
      flash[:error] = @wishlist_item.errors.full_messages.to_sentence
    end
    redirect_to wishlists_path
  end

  protected ###################################################################

  def wishlist_item_params
    params.require(:wishlist_item).permit(:min_quantity, :wishlist_id, :catalog_item_id, :catalog_item_type)
  end

end
