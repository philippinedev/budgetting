Rails.application.routes.draw do
  resources :accounts
  devise_for :users

  resources :dashboards
  resources :transactions
  resources :incomes

  root to: 'dashboards#index'
end
