Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/api/v1/posters", to: "api/v1/posters#index"
  get "api/v1/posters/:id", to: "api/v1/posters#show"
  post "/api/v1/posters", to: "api/v1/posters#create"
  delete "api/v1/posters/:id", to: "api/v1/posters#destroy"

  patch "/api/v1/posters/:id", to: "api/v1/posters#update"

  # Defines the root path route ("/")
  # root "posts#index"
end
