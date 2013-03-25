class Forecast < ActiveRecord::Base
  attr_accessible :cloud_forecast, :feels_like, :forecast, :forecast_text, :humidity, :icon, :period, :pressure, :rainfall, :snow_depth, :temperature_actual, :temperature_high, :temperature_low, :venue, :visibility, :zip
end
