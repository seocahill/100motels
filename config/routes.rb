OneHundredMotels::Application.routes.draw do

  root :to => 'pages#index'

  mount Mercury::Engine => '/'

  use_doorkeeper

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :users, only: [:index, :show] do
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
