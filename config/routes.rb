Rails.application.routes.draw do
  resources :transactions
  resources :accounts
  devise_for :users

  resources :dashboards

  root to: 'dashboards#index'
end
