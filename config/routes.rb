Rails.application.routes.draw do
  mount Avo::Engine, at: Avo.configuration.root_path

  get "/login", to: "sessions#index", as: :login
  get "/logout", to: "sessions#destroy", as: :logout

  get "/auth/:provider/callback", to: "sessions#create", as: :auth_callback
  get "/auth/failure", to: "sessions#failure", as: :auth_failure

  scope :clients do
    scope ":client", defaults: { client: "default" } do
      match "*path", to: "endpoints#handler", via: :all
    end
  end

  root to: "dashboard#index"
end
