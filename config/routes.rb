# frozen_string_literal: true

Rails.application.routes.draw do
  mount Avo::Engine, at: Avo.configuration.root_path

  get "/clients", to: "dashboard#clients", as: :clients

  get "/login", to: "sessions#index", as: :login
  get "/logout", to: "sessions#destroy", as: :logout

  get "/auth/:provider/callback", to: "sessions#create", as: :auth_callback
  get "/auth/failure", to: "sessions#failure", as: :auth_failure

  get "/requests/:id", to: "requests#show", as: :show_request

  get "/request/:id", to: "responses#show", as: :show_response

  get "/regenerate_token", to: "user#regenerate_token", as: :regenerate_token

  scope :clients do
    scope ":client", defaults: { client: "default" } do
      match "*path", to: "endpoints#handler", via: :all
    end
  end

  root to: "dashboard#index"
end
