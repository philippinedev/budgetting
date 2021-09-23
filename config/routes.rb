Rails.application.routes.draw do
  devise_for :users

  resources :transactions
  resources :accounts
  resources :dashboards

  root to: 'dashboards#index'
end
