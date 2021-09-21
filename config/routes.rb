Rails.application.routes.draw do
  devise_for :users

  resources :dashboards

  root to: 'dashboards#index'
end
