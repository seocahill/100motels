class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :number
      t.datetime :admitted
      t.uuid :order_id, null: false

      t.timestamps
    end
  end
end
