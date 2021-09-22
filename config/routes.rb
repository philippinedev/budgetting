Rails.application.routes.draw do
  resources :expense_accounts
  namespace :admin do
    resources :expenses
  end
  devise_for :users

  resources :dashboards
  resources :transactions
  resources :incomes
  resources :expenses

  root to: 'dashboards#index'
end
