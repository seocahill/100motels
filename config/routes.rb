require 'sidekiq/web'
require File.expand_path("../../lib/logged_in_constraint", __FILE__)
OneHundredMotels::Application.routes.draw do

  root :to => "users#index", as: :authenticated, constraints: LoggedInConstraint.new(true)
  root :to => "pages#index", constraints: LoggedInConstraint.new(false)

  get 'auth/:provider/callback', to: 'omniauth_callbacks#all'
  get 'auth/failure', to: redirect('/')
  post '/stripe' => 'stripe_events#listen'
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get '/info' => 'pages#info'
  get '/home' => 'pages#home'
  get '/favicon.ico', to: redirect('/')

  resources :sessions
  resources :password_resets
  resources :events, only: [:index, :update]
  resources :messages, only: [:create]


  resources :email_confirmations, only: [:create] do
    member { get :confirm }
  end

  resources :users do
    member do
      get :stripe_disconnect
    end
  end

  namespace :admin do
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

  resources :orders do
    member { get :cancel }
    collection do
      post :charge_or_refund
      post :charge_all
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # resources :events, only: :show, path: '', as: 'event'
  get '/:id', to: 'events#show', as: 'public_event'
end
