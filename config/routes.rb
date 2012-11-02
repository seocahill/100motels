OneHundredMotels::Application.routes.draw do

  mount Mercury::Engine => '/'

  use_doorkeeper

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :users, only: [:index, :show] do
    member { post :change_card }
  end

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

  resources :events, only: [:index, :show, :update] do
    member { post :request_support }
    member { post :discount }
  end

  resources :orders do
    collection do
      post :charge_multiple
    end
  end

  resources :requests, only: [:create, :destroy, :index]

  resources :locations

  if Rails.env.development?
    mount Notifier::Preview => 'mail_view'
  end

end
