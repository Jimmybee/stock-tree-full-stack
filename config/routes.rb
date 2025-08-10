Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Simple JSON health endpoint
  get "/health", to: "health#show"
  get "/healthz", to: "health#show"

  # API auth
  namespace :api do
    post "/login", to: "auth#login"
    post "/register", to: "auth#register"

    namespace :v1, defaults: { format: :json } do
  resource :user, only: [:show, :update]
  resources :teams, only: [:index, :create] do
    member do
      get :top_folder
    end
  end
  resources :folders, only: [:index, :create, :show, :update, :destroy]
  resources :products, only: [:index, :create, :show, :update, :destroy] do
    resources :batches, only: [:index, :create, :update, :destroy]
  end
  resources :tags, only: [:index, :show, :create, :update, :destroy]
  post "/sync", to: "sync#create"
    end
  end

  # Swagger docs and UI (only in dev/test by default)
  if Rails.env.development? || Rails.env.test?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end

  # Web UI routes
  resources :folders, only: [:show]
  get "/teams/:id/top_folder", to: "folders#team_root", as: :team_top_folder
  resources :products, only: [:index, :show, :update] do
    resources :batches, only: [:create, :destroy]
  end

  # Defines the root path route ("/")
  root to: "dashboard#index"
end
