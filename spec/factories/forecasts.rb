# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :forecast do
    zip 1
    period 1
    icon "MyString"
    forecast_text "MyString"
    forecast ""
    pressure "9.99"
    venue "MyString"
    visibility "9.99"
    cloud_forecast "MyString"
    temperature_actual "9.99"
    feels_like "9.99"
    temperature_high "9.99"
    temperature_low "9.99"
    humidity 1
    snow_depth "9.99"
    rainfall "9.99"
  end
end
