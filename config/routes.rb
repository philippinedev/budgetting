Rails.application.routes.draw do
  devise_for :users

  resources :dashboards
  resources :transactions
  resources :incomes
  resources :expenses

  root to: 'dashboards#index'
end
