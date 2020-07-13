Rails.application.routes.draw do
  root to: 'pages#home'

  resources :users, only: [:new, :create] do
    get 'login', on: :member
  end
end
