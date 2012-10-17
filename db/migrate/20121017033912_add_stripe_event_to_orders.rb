class AddStripeEventToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :stripe_event, :integer, default: 0, limit: 6
  end
end
