Rails.application.routes.draw do

  root "tweets#index"
  resources :users
  resources :tweets
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    resources :users
    resources :tweets do
      resources :likes
    end
  end

  post "/graphql", to: "graphql#index"
end
