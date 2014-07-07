Playmotrade::Application.routes.draw do

  devise_for :users

  constraints(:subdomain => /.+/) do
    root :to => 'stores#show'
  end

  get '/', to: 'home#index'

  match '/' => 'home#index', :via => :get, :constraints => { :subdomain => /^(|www)$/ }
  resources :home
  resources :users
  resources :carts
  resources :catalog
  resources :catalog_sets do
    member do
      get :inventory
    end
  end
  resources :catalog_parts do
    collection do
      get :klickies
    end
  end

  if Rails.env.development?
    resources :checkout
    resources :payment_processor
    match '/checkout/new/:cart_id', :as => :cart_checkout, :via => :get, :to => 'checkout#new'
  else
    # Force SSL on these routes.....
    scope :protocol => 'https://', :constraints => { :protocol => 'https://' } do
      resources :checkout
      resources :payment_processor
    end
    match '/payment_processor', :as => :payment_processor, :via => :get, :to => 'payment_processor#index'
    match '/checkout/new/:cart_id', :as => :cart_checkout, :via => :get, :to => 'checkout#new'
  end

  resources :search
  resources :orders
  resources :wishlists do
    collection do
      post :add_item
    end
    member do
      post :email
    end
  end
  match '/wishlists/:id/remove_item/:item_id', :as => :remove_wishlist_item, :via => :delete, :to => 'wishlists#remove_item'
  resources :stores do
    member do
      post :break_in
      get :store_closed
      get :search
      post :add_items_to_cart
      get :cart
      get :inventory
      get :wishlist
    end
  end
  match '/stores/:id/add_part_to_inventory/:part_id', :as => :add_part_to_inventory, :via => :post, :to => 'stores#add_part_to_inventory'
  match '/stores/:id/add_set_to_inventory/:set_id', :as => :add_set_to_inventory, :via => :post, :to => 'stores#add_set_to_inventory'
  match '/stores/:id/inventory/:type', :as => :store_inventory, :via => :get, :to => 'stores#inventory'
  match '/stores/:id/wishlist/:wishlist_id/:type', :as => :store_wishlist, :via => :get, :to => 'stores#wishlist'
  match '/stores/:id/remove/:item_id', :as => :remove_items_from_cart, :via => :delete, :to => 'stores#remove_items_from_cart'

end
