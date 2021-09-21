Rails.application.routes.draw do
  devise_for :users

  resources :dashboards
  resources :transactions

  root to: 'dashboards#index'
end
