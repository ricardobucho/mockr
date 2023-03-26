Rails.application.routes.draw do
  constraints(UserConstraint.new(&:manager?)) do
    mount Avo::Engine, at: Avo.configuration.root_path
  end

  get "/auth/:provider/callback", to: "sessions#create", as: :auth_callback
  get "/auth/failure", to: "sessions#failure", as: :auth_failure
  get "/auth/logout", to: "sessions#destroy", as: :auth_logout

  if ActiveRecord::Base.connected?
    namespace :clients do
      Client.includes(requests: :responses).find_each do |client|
        namespace client.slug do
          client.requests.each do |request|
            request.responses.each do |response|
              send(
                request.method.downcase.to_sym,
                request.path,
                to: ->(_env) {
                  [
                    response.status,
                    {
                      "Content-Type" => "application/json",
                      **response.headers,
                    },
                    [response.body],
                  ]
                },
              )
            end
          end
        end
      end
    end
  end

  root to: "sessions#index"
end
