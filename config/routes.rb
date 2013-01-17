OneHundredMotels::Application.routes.draw do

  get "sessions/new"

  root :to => 'pages#index'

  use_doorkeeper

  post 'auth/:provider/callback', to: 'omniauth_callbacks#all'

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
