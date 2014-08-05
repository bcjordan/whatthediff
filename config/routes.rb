Rails.application.routes.draw do
  resources :page_lists

  post 'snap' => 'snapshots#trigger'
  post '/snapshots/receive/:id' => 'snapshots#receive'
  post '/diffs/receive/:id' => 'snapshots#receive_diff'
  get '/dashboard/:secret_key' => 'snapshots#dashboard', as: 'snapshots_dashboard'
  get '/dashboard/trigger/:secret_key' => 'snapshots#trigger_list_capture_secret', as: 'trigger_capture_secret'
  post '/api/v0/:secret_key/trigger' => 'snapshots#trigger_list_capture_api_secret', as: 'trigger_capture_api'
  get 'snapshots/trigger/:list_id' => 'snapshots#trigger_list_capture', as: 'trigger_list_capture'
  get 'snapshots/trigger'

  resources :users, :only => [:index, :show]
  root to: 'visitors#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
