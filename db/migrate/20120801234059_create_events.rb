class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :artist
      t.string :venue
      t.date :date
      t.time :doors
      t.decimal :ticket_price, precision: 8 , scale: 2
      t.integer :state, default: 0, limit: 6
      t.boolean :visible, default: false

      t.timestamps
    end
  end
end
