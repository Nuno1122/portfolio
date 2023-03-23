Rails.application.routes.draw do
  root 'tops#index'
  get 'tops/index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resources :users, only: %i[new create destroy]
  resources :posts, only: %i[index]
end