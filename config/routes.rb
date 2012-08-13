OneHundredMotels::Application.routes.draw do

  devise_for :users
  
  root :to => 'pages#home'
  
  namespace :admin do 
    root :to => 'base#index'
    resources :users
  end

  resources :events 

  resources :carts, except: :index

end
