require 'sidekiq/web'
require File.expand_path("../../lib/logged_in_constraint", __FILE__)

OneHundredMotels::Application.routes.draw do
  root :to => "admin/events#index", as: :authenticated, constraints: LoggedInConstraint.new(true)
  root :to => "pages#index", constraints: LoggedInConstraint.new(false)

  get 'auth/:provider/callback', to: 'omniauth_callbacks#all'
  get 'auth/failure', to: redirect('/')

  get 'sign-up', to: 'users#new', as: 'signup'
  get 'sign-in', to: 'sessions#new', as: 'login'
  get 'sign-out', to: 'sessions#destroy', as: 'logout'

  get '/info' => 'pages#info'
  get '/home' => 'pages#home'

  resources :users
  resources :sessions
  resources :password_resets
  resources :events, only: [:index, :update, :show]
  resources :email_confirmations, only: [:create] do
    member { get :confirm }
  end
  namespace :admin do
    resources :events do
      resources :messages
      resources :tickets do
        collection { get :check }
      end
    end
  end
  resources :orders do
    member {get :cancel}
  end
  resources :charges, only: [:create] do
    collection { post :receive }
  end

  mount Sidekiq::Web, at: '/sidekiq'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
