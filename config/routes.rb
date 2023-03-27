Rails.application.routes.draw do
  constraints(UserConstraint.new(&:manager?)) do
    mount Avo::Engine, at: Avo.configuration.root_path
  end

  get "/auth/:provider/callback", to: "sessions#create", as: :auth_callback
  get "/auth/failure", to: "sessions#failure", as: :auth_failure
  get "/auth/logout", to: "sessions#destroy", as: :auth_logout

  scope :clients do
    scope ":client", defaults: { client: "default" } do
      match "*path", to: "endpoints#handler", via: :all
    end
  end

  root to: "sessions#index"
end
