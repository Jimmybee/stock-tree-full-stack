Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Simple JSON health endpoint
  get "/health", to: "health#show"

  # API auth
  namespace :api do
    post "/login", to: "auth#login"
    post "/register", to: "auth#register"

    namespace :v1 do
  resource :user, only: [:show, :update]
  resources :teams, only: [:index, :create]
    end
  end

  # Defines the root path route ("/")
  root to: "health#show"
end
