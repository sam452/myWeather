MyWeather::Application.routes.draw do
  
  resources :forecasts

  namespace :api do
    resources :venues
   end

  #match ':grand(/:get_data(/:id))(.:format)'
  
  root :to => 'forecasts#index'


end
