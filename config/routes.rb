Rails.application.routes.draw do
  resources :user_links, only: [:index, :create, :update, :destroy]
  resources :user_tokens, only: [:create, :destroy]
  resources :users, only: [:update]
end
