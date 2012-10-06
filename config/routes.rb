OneHundredMotels::Application.routes.draw do

  mount Doorkeeper::Engine => '/oauth'

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :users, only: [:index, :show]

  root :to => 'pages#home'

  match '/info' => 'pages#info'

  namespace :promoter do
    root :to => 'base#index'
    resources :users
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :events
    end
  end

  resources :events

  resources :carts, except: :index

  resources :line_items

  resources :orders

  if Rails.env.development?
    mount Notifier::Preview => 'mail_view'
  end

end
