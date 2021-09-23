Rails.application.routes.draw do
  devise_for :users

  resources :dashboards
  resources :transactions
  resources :accounts
  resources :transaction_types

  root to: 'dashboards#index'
end
