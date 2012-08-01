class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :artist
      t.string :venue
      t.date :date
      t.time :doors

      t.timestamps
    end
  end
end
