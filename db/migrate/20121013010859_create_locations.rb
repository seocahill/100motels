class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address
      t.string :city
      t.string :country
      t.string :zip
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :locations, [:latitude, :longitude]
  end
end
