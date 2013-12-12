class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :datetime
      t.decimal :ticket_price, precision: 8 , scale: 2
      t.boolean :visible, default: false

      t.timestamps
    end
  end
end
