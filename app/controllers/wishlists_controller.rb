class WishlistsController < ApplicationController

  def index
    if user_signed_in? && current_user.wishlists.blank?
      Wishlist.create(:user_id => current_user.id, :name => "Main Wishlist")
    end
    @wishlists = current_user.wishlists.paginate(:page => params[:my_page], :per_page => 10)
    @public_wishlists = Wishlist.public.paginate(:page => params[:public_page], :per_page => 10)
  end

  def show
    @wishlist       = Wishlist.find(params[:id])
    @wishlist_items = @wishlist.wishlist_items.paginate(:page => params[:page], :per_page => 30)
  end

  def add_item
    new_wishlist = Wishlist.find_or_create(user_id: current_user.id, name: params[:new_wishlist_name], public: params.fetch(:new_wishlist_public, false))
    if new_wishlist.valid?
      wishlist_item_params.delete(:wishlist)
      @wishlist_item = WishlistItem.new(wishlist_item_params.merge!(wishlist: new_wishlist))
    else
      @wishlist_item = WishlistItem.find_or_initialize_by(wishlist_id: wishlist_item_params[:wishlist_id], catalog_item_id: wishlist_item_params[:catalog_item_id])
      @wishlist_item.update_attributes(wishlist_item_params)
    end

    if @wishlist_item.save
      flash[:notice] = "Item added to wishlist: #{@wishlist_item.wishlist.name}"
    else
      flash[:error] = @wishlist_item.errors.full_messages.to_sentence
    end
    redirect_to wishlists_path
  end

  def remove_item
    @wishlist      = Wishlist.find(params[:id])
    @wishlist_item = WishlistItem.find(params[:item_id])
    if @wishlist_item.destroy
      flash[:notice] = "Item removed from wishlist: #{@wishlist_item.wishlist.name}"
    else
      flash[:error] = @wishlist_item.errors.full_messages.to_sentence
    end
    redirect_to wishlists_path
  end

  def destroy
    @wishlist = Wishlist.find(params[:id])
    if @wishlist.destroy
      flash[:notice] = "Wishlist: #{@wishlist.name} deleted."
    else
      flash[:error] = @wishlist.errors.full_messages.to_sentence
    end
    redirect_to wishlists_path
  end

  protected ###################################################################

  def wishlist_item_params
    params.require(:wishlist_item).permit(:min_quantity, :wishlist_id, :catalog_item_id, :catalog_item_type)
  end

end
