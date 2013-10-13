Playmotrade::Application.routes.draw do

  devise_for :users

  constraints(:subdomain => /.+/) do
    root :to => 'stores#show'
    resources :store_search
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
    end
  end

end
