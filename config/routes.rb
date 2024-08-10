Rails.application.routes.draw do
  resources :user_links, only: [:index, :create, :update, :destroy]
  patch "/users/update", to: "users#update", as: :user_update

  post "users/sign_in", to: "users/sessions#create", as: :user_session
  delete "users/sign_out", to: "users/sessions#destroy", as: :destroy_user_session

  post "users", to: "users/registrations#create", as: :user_registration

  patch "/users/update_email_token", to: "users/update_email_tokens#update", as: :user_update_email_token 
  patch "/users/reset_password_token", to: "users/reset_password_tokens#update", as: :user_reset_password_token
  patch "/users/email", to: "users/emails#update", as: :user_email
  patch "/users/password", to: "users/passwords#update", as: :user_password
end
