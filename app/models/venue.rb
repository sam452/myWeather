class Venue < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :lattitude, :longitude, :state, :static_file, :zip
end
