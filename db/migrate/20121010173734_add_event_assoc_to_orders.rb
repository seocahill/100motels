class AddEventAssocToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :event_id, :integer
    add_index :orders, :event_id
    add_column :orders, :quantity, :integer
  end
end
