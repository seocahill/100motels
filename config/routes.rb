OneHundredMotels::Application.routes.draw do

  mount Mercury::Engine => '/'

  mount Doorkeeper::Engine => '/oauth'

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :users, only: [:index, :show]

  root :to => 'pages#home'

  match '/info' => 'pages#info'

  namespace :promoter do
    root :to => 'events#index'
    resources :events
    resources :profiles
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :events
    end
  end

  resources :events, only: [:index, :show] do
    member { post :mercury_update }
  end

  resources :orders do
    collection do
      post :charge_multiple
      post :refund_multiple
    end
  end

  resources :locations

  if Rails.env.development?
    mount Notifier::Preview => 'mail_view'
  end

end
