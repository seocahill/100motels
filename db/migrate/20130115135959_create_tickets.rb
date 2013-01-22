class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :number
      t.references :order
      t.references :event
      t.datetime :admitted
      t.integer :quantity_counter

      t.timestamps
    end
    add_index :tickets, :order_id
    add_index :tickets, :event_id
  end
end
