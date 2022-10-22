Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#index'
  get '/manual/description', to: 'manual#description'
  post '/histories/create/morning', to: 'histories#create_morning'
  post '/histories/create/noon', to: 'histories#create_noon'
  post '/histories/create/night', to: 'histories#create_night'
  post '/histories/create/yesterday_night', to: 'histories#create_yesterday_night'
  get '/histories/next_month', to: 'histories#next_month'
  get '/histories/prev_month', to: 'histories#prev_month'
  get '/histories/show', to: 'histories#show'
  resources :regions
  post '/regions/:id/add_to_top', to: 'regions#add_to_top'
  post '/regions/add_interval', to: 'regions#add_interval'
end
