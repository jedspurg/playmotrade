Playmotrade::Application.routes.draw do

  devise_for :users
  
  root 'home#index'

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

end
