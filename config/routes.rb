require 'sidekiq/web'

OneHundredMotels::Application.routes.draw do

  # root :to => "users#show", :constraints => Authentication.new
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

  resources :sessions
  resources :password_resets
  resources :events, only: [:show, :index, :update]
  resources :messages, only: [:create]


  resources :email_confirmations, only: [:create] do
    member { get :confirm }
  end

  resources :users do
    member do
      put :change_card
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

end
