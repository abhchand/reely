Rails.application.routes.draw do
  # rubocop:disable Style/SymbolArray
  # rubocop:disable LineLength
  root to: "site#index"

  mount Sidekiq::Web => "/sidekiq", constraints: Sidekiq::AdminConstraint.new

  post "/log-in", to: "sessions#create"
  get "/log-out", to: "sessions#destroy"

  resources :collections, only: [:index, :show, :create, :update, :destroy] do
    put "add-photos" => "collections#add_photos"
  end

  resources :photos, only: :index

  namespace :photos do
    resources :source_file, only: :show, path: :file
  end

  resources :c, only: :show, controller: :shared_collections, as: "shared_collection"
  # rubocop:enable LineLength
  # rubocop:enable Style/SymbolArray
end
