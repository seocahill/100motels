require 'sidekiq/web'

OneHundredMotels::Application.routes.draw do

  root :to => "organizer/events#index", :constraints => Authentication.new
  root :to => "pages#index"

  get 'auth/:provider/callback', to: 'omniauth_callbacks#all'
  get 'auth/failure', to: redirect('/')
  post '/stripe' => 'stripe_events#listen'
  get 'signup', to: 'member_profiles#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get '/info' => 'pages#info'
  get '/home' => 'pages#home'
  get '/favicon.ico', to: redirect('/')
  get '/organizer', to: redirect('/')

  resources :sessions
  resources :member_profiles, only: [:new, :create, :edit, :update]
  resources :guest_profiles, only: [:create]
  resources :password_resets
  resources :events, only: [:show, :index, :update]
  resources :locations, only: [:new, :show, :create, :update]
  resources :messages, only: [:create]


  resources :email_confirmations, only: [:create] do
    member { get :confirm }
  end

  resources :users do
    member { put :change_card }
  end

  resources :orders do
    collection do
      post :charge_or_refund
      post :charge_all
      put :cancel
    end
  end

  namespace :organizer do
    resources :events do
      member do
        get :cancel
        get :duplicate
        post :defer_or_cancel
        get :admit
      end
      resources :tickets, only: [:index, :update]
      resources :event_users
    end
  end

  use_doorkeeper
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :events
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
