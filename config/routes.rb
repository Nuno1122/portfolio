Rails.application.routes.draw do
  root 'tops#index'
  get 'tops/index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  get 'home_screens', to: 'home_screens#index'
  post 'guest_login', to: 'user_sessions#guest_login'
  delete 'logout', to: 'user_sessions#destroy'
  resources :users, only: %i[new create destroy]
  resources :posts, only: %i[new create index destroy]
  resources :start_time_plans, only: [:new, :create, :edit, :update]
end
