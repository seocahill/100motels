class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.decimal :total
      t.string :stripe_customer_token
      t.integer :user_id
      t.integer :event_id
      t.integer :quantity, default: 1
      t.integer :stripe_event, default: 0, limit: 6
      t.string :stripe_charge_id
      t.string :last4

      t.timestamps
    end
    add_index :orders, :user_id
    add_index :orders, :event_id
  end
end
