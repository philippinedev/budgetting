Rails.application.routes.draw do
  resources :transactions
  resources :accounts
  devise_for :users

  resources :dashboards
  resources :incomes
  resources :expenses

  root to: 'dashboards#index'
end
