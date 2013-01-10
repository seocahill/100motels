OneHundredMotels::Application.routes.draw do

  mount Mercury::Engine => '/'

  use_doorkeeper

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :users, only: [:index, :show] do
    member { put :change_card }
  end

  root :to => 'pages#home'

  get '/info' => 'pages#info'

  namespace :organizer do
    root :to => 'events#index'
    resources :events
    resources :profiles
    resources :requests, only: [:index]
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :events
    end
  end

  resources :events do
    member { post :request_support }
    member { post :discount }
  end

  resources :profiles, only: [:index, :show]

  resources :orders do
    collection do
      post :charge_or_refund
    end
  end

  resources :requests, only: [:create, :destroy]  do
    collection do
      post :mark_read
    end
  end

  resources :locations

  post '/stripe' => 'stripe_events#listen'

  if Rails.env.development?
    mount Notifier::Preview => 'mail_view'
  end

end
