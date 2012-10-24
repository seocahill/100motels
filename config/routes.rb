OneHundredMotels::Application.routes.draw do

  get "hooks/receiver"

  mount Mercury::Engine => '/'

  mount Doorkeeper::Engine => '/oauth'

  match '/hook' => 'hooks#receiver'

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :users, only: [:index, :show]
  root :to => 'pages#home'

  match '/info' => 'pages#info'

  namespace :promoter do
    root :to => 'base#index'
    resources :events
    resources :profiles
    match '/requests' => 'base#requests'
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :events
    end
  end

  resources :events, only: [:index, :show] do
    member { post :mercury_update }
    member { post :request_support }
  end

  resources :orders do
    collection do
      post :charge_multiple
    end
  end

  resources :locations

  if Rails.env.development?
    mount Notifier::Preview => 'mail_view'
  end

end
