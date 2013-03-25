MyWeather::Application.routes.draw do
  
  resources :forecasts
  
  root :to => 'forecasts#index'
end
