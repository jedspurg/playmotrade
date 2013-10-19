Playmotrade::Application.routes.draw do

  devise_for :users

  constraints(:subdomain => /.+/) do
    root :to => 'stores#show'
  end

  get '/', to: 'home#index'

  match '/' => 'home#index', :via => :get, :constraints => { :subdomain => /^(|www)$/ }
  resources :home
  resources :users
  resources :catalog
  resources :catalog_sets do
    member do
      get :inventory
    end
  end
  resources :catalog_parts
  resources :search
  resources :stores do
    member do
      get :break_in
      get :store_closed
      post :add_part_to_inventory
      post :add_set_to_inventory
      get :search
      post :add_items_to_cart
      get :cart
    end
  end
  match '/stores/:id/inventory/:type', :as => :store_inventory, :via => :get, :to => 'stores#inventory'
  match '/stores/:id/remove/:item_id', :as => :remove_items_from_cart, :via => :delete, :to => 'stores#remove_items_from_cart'

end
