require Rails.root.join("lib", "sidekiq", "admin_constraint")
require Rails.root.join("lib", "admin", "mailer_preview_constraint")

Rails.application.routes.draw do
  # rubocop:disable Metrics/LineLength
  # rubocop:disable Style/SymbolArray
  root to: "root#new"

  scope :admin do
    mount Sidekiq::Web => "/sidekiq", constraints: Sidekiq::AdminConstraint.new

    unless Rails.env.production?
      get(
        "/rails/mailers" => "rails/mailers#index",
        constraints: Admin::MailerPreviewConstraint.new,
        as: "admin_rails_mailers"
      )

      get(
        "/rails/mailers/*path" => "rails/mailers#preview",
        constraints: Admin::MailerPreviewConstraint.new
      )
    end
  end

  devise_for(
    :users,
    controllers: {
      confirmations: "devise/custom/confirmations",
      omniauth_callbacks: "devise/custom/omniauth_callbacks",
      passwords: "devise/custom/passwords",
      registrations: "devise/custom/registrations",
      sessions: "devise/custom/sessions"
    },
    path_names: {
      sign_in:  "log-in",
      sign_out: "log-out",
      sign_up:  "new",
      registration:  "registrations"
    },
    sign_out_via: :get
  )

  namespace :account do
    resources :profile, only: :index
  end

  resources :admin, only: [:index]

  namespace :admin do
    resources :audits, only: [:index]
    resources :users, only: [:index]
    resources :user_roles, only: [:update]
  end

  resources :c, only: :show, controller: "collections/sharing_display", as: "collections_sharing_display"

  resources :collections, only: [:index, :show, :create, :update, :destroy] do
    get "accessibility" => "collections#accessibility"
    put "add-photos" => "collections#add_photos"
    put "remove-photos" => "collections#remove_photos"

    resources :downloads, controller: "collections/downloads", only: [:show, :create] do
      get :status
    end

    resource :sharing_config, only: [:show, :update], controller: "collections/sharing_config" do
      post "renew-link" => "collections/sharing_config#renew_link"
    end
  end

  namespace :api, defaults: { format: "json" } do
    scope path: "v1", module: :v1, as: :v1 do
      resources :users, only: [:index, :show, :update]
      resources :user_invitations, only: [:index]
    end
  end

  resources :deactivated_users, only: [:index, :destroy]

  resources :photos, only: [:index, :create, :new]

  resources :product_feedbacks, only: :create

  scope :photos do
    resources :raw_photos, only: :show, path: :file
  end

  resources :users, only: [:index, :destroy]

  resources :user_invitations, only: [:create, :destroy]

  # rubocop:enable Style/SymbolArray
  # rubocop:enable Metrics/LineLength
end
