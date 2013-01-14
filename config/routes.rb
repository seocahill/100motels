OneHundredMotels::Application.routes.draw do

  root :to => 'pages#home'

  mount Mercury::Engine => '/'

  use_doorkeeper

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :users, only: [:index, :show] do
    member { put :change_card }
  end

  post '/stripe' => 'stripe_events#listen'

  get '/info' => 'pages#info'

  namespace :organizer do
    root :to => 'events#index'
    resources :events
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :events
    end
  end

  resources :events do
    member { post :request_support }
  end

  resources :orders do
    collection do
      post :charge_or_refund
    end
  end

  resources :locations

  if Rails.env.development?
    mount Notifier::Preview => 'mail_view'
  end

end
