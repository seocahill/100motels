class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.decimal :total, null: false
      t.decimal :ticket_price, null: false
      t.string :stripe_customer_token, null: false
      t.integer :event_id, null: false
      t.integer :quantity, default: 1
      t.integer :stripe_event, default: 0, limit: 6
      t.string :stripe_charge_id
      t.string :last4

      t.timestamps
    end
    add_index :orders, :event_id
  end
end
