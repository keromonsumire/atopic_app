Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#index'
  post '/histories/create/morning', to: 'histories#create_morning'
  post '/histories/create/noon', to: 'histories#create_noon'
  post '/histories/create/night', to: 'histories#create_night'
  get '/histories/show', to: 'histories#show'
  resources :regions
end
