Rails.application.routes.draw do
  # rubocop:disable Style/SymbolArray
  root to: "site#index"

  mount Sidekiq::Web => "/sidekiq", constraints: Sidekiq::AdminConstraint.new

  post "/log-in", to: "sessions#create"
  get "/log-out", to: "sessions#destroy"

  resources :collections, only: [:index, :show, :update, :destroy]

  resources :photos, only: :index

  namespace :photos do
    resources :source_file, only: :show, path: :file
  end
  # rubocop:enable Style/SymbolArray
end
