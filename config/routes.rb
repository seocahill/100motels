OneHundredMotels::Application.routes.draw do

  root :to => 'pages#index'

  get 'auth/:provider/callback', to: 'omniauth_callbacks#all'
  get 'auth/failure', to: redirect('/')
  post '/stripe' => 'stripe_events#listen'
  get 'signup', to: 'member_profiles#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get '/info' => 'pages#info'
  get '/home' => 'pages#home'

  resources :sessions
  resources :member_profiles, only: [:new, :create]
  resources :guest_profiles, only: [:create]
  resources :password_resets
  resources :events
  resources :locations

  resources :users do
    member { put :change_card }
  end

  resources :orders do
    collection do
      post :charge_or_refund
    end
  end

  namespace :organizer do
    root :to => 'events#index'
    resources :events do
      member do
        put :cancel
      end
      resources :tickets, only: [:index, :update]
    end
  end

  use_doorkeeper
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :events
    end
  end
end
