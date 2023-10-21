# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'vacations#index'

  devise_for :users

  resources :vacations
end
