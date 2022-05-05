Rails.application.routes.draw do

  root "tweets#index"
  resources :users
  resources :tweets

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  # Sessions
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  namespace :api do
    resources :users do
      get :me, on: :collection # rails routes | grep "#me"
    end

    resources :tweets do
      resources :likes
    end

    post '/auth/login', to: 'authentication#login'
  end

  post "/graphql", to: "graphql#index"
end
