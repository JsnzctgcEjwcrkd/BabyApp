# frozen_string_literal: true

Rails.application.routes.draw do
  get 'demo/show'
  get 'chart/index'
  get 'nursery_support/index'
  root to: 'logs#index'
  get 'demo', to: 'demo#show'
  devise_for :users
  resources :description
  resources :logs
  get 'logs_ajax', to: 'logs#logs_ajax'
  post 'versions/:id/revert' => 'versions#revert', :as => 'revert_version'

  get 'setting', to: 'settings#edit'
  patch 'setting', to: 'settings#update'
  get 'birth_setting', to: 'settings#edit_birth_setting'
  patch 'birth_setting', to: 'settings#update_birth_setting'

  get 'terms_of_service', to: 'terms#service'
  get 'privacy_policy', to: 'terms#privacy_policy'
end
