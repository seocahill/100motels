class AddEventToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :event_id, :integer
    add_index :locations, :event_id
  end
end
