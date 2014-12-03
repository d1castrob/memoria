Rails.application.routes.draw do


  # pagina de inicio

  root 'welcome#index'

  # login con twitter por si fuese necesario

  get "/auth/:provider/callback" => "sessions#create"

  get "/signout" => "sessions#destroy", :as => :signout

  # de utilidad

  get "/algo" => "sessions#show"

  get "/run" => "sessions#run"

  get "/users_cleanup" => "users#cleanup"

  #vistas de grafos

  get "/social_graph" => "users#social_graph"

  get "/semantic_graph" => "expressions#semantic_graph"

  get "/time_distance_graph" => "messages#time_distance_graph"

  get "/text_distance_graph" => "messages#text_distance_graph"

  get "/geo_distance_graph" => "messages#geo_distance" 

  # retornos de data en json

  get "/social_graph_data" => "users#data"

  get "/semantic_graph_data" => "expressions#semantic"

  get "/time_distance_graph_data" => "messages#time_distance"

  get "/text_distance_graph_data" => "messages#text_distance"

  get "/geo_distance_graph_data" => "messages#geo_distance"

  # generico

  resources :users

  resources :messages

  resources :edges


end
