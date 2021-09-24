Rails.application.routes.draw do
  root to: 'dashboards#index'

  devise_for :users

  resources :dashboards
  resources :transactions
  resources :accounts
  resources :transaction_types
end
