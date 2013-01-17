OneHundredMotels::Application.routes.draw do

  root :to => 'pages#index'

  use_doorkeeper

  post 'auth/:provider/callback', to: 'omniauth_callbacks#all'

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions

  resources :users do
    member { put :change_card }
  end

  post '/stripe' => 'stripe_events#listen'

  get '/info' => 'pages#info'
  get '/home' => 'pages#home'

  namespace :organizer do
    root :to => 'events#index'
    resources :events do
      member do
        put :cancel
      end
      resources :tickets, only: [:index, :update]
    end
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :events
    end
  end

  resources :events

  resources :orders do
    collection do
      post :charge_or_refund
    end
  end

  resources :locations
end
