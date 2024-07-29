Rails.application.routes.draw do
  resources :user_links, only: [:index, :create, :update, :destroy]
  resources :users, only: [:update]

  post "users/sign_in", to: "users/sessions#create", as: :user_session
  delete "users/sign_out", to: "users/sessions#destroy", as: :destroy_user_session

  post "users", to: "users/registrations#create", as: :user_registration
end
