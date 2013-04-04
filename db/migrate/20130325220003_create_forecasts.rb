class CreateForecasts < ActiveRecord::Migration
  def change
    create_table :forecasts do |t|
      t.integer :zip
      t.integer :period
      t.string :icon
      t.string :forecast_text
      t.decimal :precipitation
      t.decimal :pressure
      t.string :venue
      t.decimal :visibility
      t.string :cloud_forecast
      t.decimal :temperature_actual
      t.decimal :feels_like
      t.decimal :temperature_high
      t.decimal :temperature_low
      t.integer :humidity
      t.decimal :snow_depth
      t.decimal :rainfall

      t.timestamps
    end
  end
end
