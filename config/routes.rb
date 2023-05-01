Rails.application.routes.draw do
  root 'tops#index'
  get 'tops/index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  post 'guest_login', to: 'user_sessions#guest_login'
  post "oauth/callback", to: "oauths#callback"
  get 'oauth/callback', to: 'oauths#callback'
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  delete 'logout', to: 'user_sessions#destroy'
  resources :users, only: %i[new create destroy]
  resources :posts, only: %i[new create index destroy]
  resources :start_time_plans, only: %i[new create edit update]
  resources :morning_activity_logs, only: %i[index create]
end
