Rails.application.routes.draw do
  get 'summaries/index'
  root to: 'dashboards#index'

  devise_for :users

  resources :dashboards
  resources :transactions
  resources :incomes
  resources :salary_expenses
  resources :expenses
  resources :accounts do
    member do
      patch 'deactivate'
      patch 'activate'
    end
  end
  resources :transaction_types
  resources :account_types
  resources :summaries, only: [:index, :show]
end
