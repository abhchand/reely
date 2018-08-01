Rails.application.routes.draw do
  # rubocop:disable Style/SymbolArray
  root to: "site#index"

  post "/log-in", to: "sessions#create"
  get "/log-out", to: "sessions#destroy"

  resources :collections, only: [:index, :show, :update]
  resources :photos, only: :index
  # rubocop:enable Style/SymbolArray
end
