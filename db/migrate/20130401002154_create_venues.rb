class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :static_file
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :lattitude
      t.string :longitude

      t.timestamps
    end
  end
end
