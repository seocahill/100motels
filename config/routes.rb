require 'sidekiq/web'
require File.expand_path("../../lib/logged_in_constraint", __FILE__)
OneHundredMotels::Application.routes.draw do

  root :to => "users#show", as: :authenticated, constraints: LoggedInConstraint.new(true)
  root :to => "pages#index", constraints: LoggedInConstraint.new(false)

  get 'auth/:provider/callback', to: 'omniauth_callbacks#all'
  get 'auth/failure', to: redirect('/')
  post '/stripe' => 'stripe_events#listen'
  get 'sign-up', to: 'users#new', as: 'signup'
  get 'sign-in', to: 'sessions#new', as: 'login'
  get 'sign-out', to: 'sessions#destroy', as: 'logout'
  get '/info' => 'pages#info'
  get '/home' => 'pages#home'
  # get '/favicon.ico', to: redirect('/')

  resources :users
  resources :sessions
  resources :password_resets
  resources :events, only: [:index, :update, :show]

  resources :email_confirmations, only: [:create] do
    member { get :confirm }
  end


  namespace :admin do
    resources :events do
      member do
        get :cancel
        get :duplicate
        post :defer_or_cancel
        get :admit
      end
      resources :messages
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
  # get '/:id', to: 'events#show', as: 'public_event'
end
