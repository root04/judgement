Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get 'home/show'
  root 'home#index'

  resources :user, only: [:edit, :update]
end
