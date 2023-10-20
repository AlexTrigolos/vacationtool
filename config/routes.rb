Rails.application.routes.draw do
  root to: 'vacations#index'

  devise_for :users

  resources :vacations
end
