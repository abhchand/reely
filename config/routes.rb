require Rails.root.join("lib", "sidekiq", "admin_constraint")
require Rails.root.join("lib", "admin", "mailer_preview_constraint")

Rails.application.routes.draw do
  # rubocop:disable LineLength
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
      omniauth_callbacks: "devise/callbacks"
    },
    path_names: {
      sign_in:  "log-in",
      sign_out: "log-out",
      sign_up:  "new",
      registration:  "registrations"
    },
    sign_out_via: :get
  )

  # Devise generates an "edit" route for user registrations and there doesn't
  # seem to be a clean way to remove a single generated route, so just redirect.
  #   See: https://stackoverflow.com/a/6883757/2490003
  #
  # Note: This overrides but does not replace the original route created by
  # by Devise:
  #  get(
  #    "/users/registrations/edit",
  #    to: "devise/registrations#edit",
  #    as: "edit_user_registration"
  #  )
  get "/users/registrations/edit", to: redirect("/account/profile")

  namespace :account do
    resources :profile, only: :index
  end

  resources :collections, only: [:index, :show, :create, :update, :destroy] do
    get "accessibility" => "collections#accessibility"
    put "add-photos" => "collections#add_photos"
  end

  resources :photos, only: :index

  namespace :photos do
    resources :source_file, only: :show, path: :file
  end

  resources :c, only: :show, controller: :shared_collections, as: "shared_collection"
  # rubocop:enable Style/SymbolArray
  # rubocop:enable LineLength
end
