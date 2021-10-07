# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'dashboards#index'

  devise_for :users

  resources :dashboards
  resources :transactions
  resources :transaction_types
  resources :entities
  resources :accounts do
    member do
      patch 'init'
      patch 'deactivate'
      patch 'activate'
    end
  end

  # resources :summaries, only: [:index, :show]
  # get 'summaries/index'
  get '*path', to: 'application#routing_error'
end
