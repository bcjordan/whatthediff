Rails.application.routes.draw do
  post 'snap' => 'snapshots#trigger'
  post '/snapshots/receive/:id' => 'snapshots#receive'
  get 'snapshots/trigger'

  resources :users, :only => [:index, :show]
  root to: 'visitors#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
