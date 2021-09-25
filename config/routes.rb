Rails.application.routes.draw do
  get 'summaries/index'
  root to: 'dashboards#index'

  devise_for :users

  resources :dashboards
  resources :transactions
  resources :accounts
  resources :transaction_types
  resources :summaries, only: [:index, :show]
end
