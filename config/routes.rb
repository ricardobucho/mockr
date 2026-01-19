# frozen_string_literal: true

Rails.application.routes.draw do
  # Manage namespace for admin CRUD operations
  namespace :manage do
    resources :clients, only: %i[index new create edit update destroy] do
      member { get :delete }
      resources :requests, only: %i[new create]
    end
    resources :requests, only: %i[edit update destroy] do
      member { get :delete }
      resources :responses, only: %i[new create]
      resources :indices, only: %i[new create]
    end
    resources :responses, only: %i[edit update destroy] do
      member { get :delete }
    end
    resources :indices, only: %i[edit update destroy] do
      member { get :delete }
    end
    resources :users, only: %i[index edit update]
  end

  get "/clients", to: "dashboard#clients", as: :clients

  get "/login", to: "sessions#index", as: :login
  get "/logout", to: "sessions#destroy", as: :logout

  # Development-only: direct login bypass
  if Rails.env.development?
    get "/dev_login", to: "sessions#dev_login", as: :dev_login
  end

  get "/auth/:provider/callback", to: "sessions#create", as: :auth_callback
  get "/auth/failure", to: "sessions#failure", as: :auth_failure

  get "/indices/:id", to: "indices#show", as: :show_index

  get "/requests/:id", to: "requests#show", as: :show_request

  get "/request/:id", to: "responses#show", as: :show_response

  get "/regenerate_token", to: "user#regenerate_token", as: :regenerate_token

  scope "(/clients)/:client", defaults: { client: "default" } do
    match "/", to: "endpoints#show", via: :all
    match "*path", to: "endpoints#show", via: :all
  end

  root to: "dashboard#index"
end
