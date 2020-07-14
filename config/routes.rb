Rails.application.routes.draw do
  root to: 'lunches#index'

  resources :users, only: [:new, :create] do
    get 'login', on: :member
  end

  resources :lunches, only: [:index, :create]
end
