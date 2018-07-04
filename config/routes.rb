Rails.application.routes.draw do
  root to: "site#index"

  post "/log-in", to: "sessions#create"
  get "/log-out", to: "sessions#destroy"

  resources :collections, only: :index
  resources :home, only: :index
end
