OneHundredMotels::Application.routes.draw do

  devise_for :users
  
  resources :users, only: [:index, :show]

  root :to => 'pages#home'
  
  namespace :admin do 
    root :to => 'base#index'
    resources :users
  end

  resources :events 

  resources :carts, except: :index

  resources :line_items

  resources :orders

end
