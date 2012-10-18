class AddChargeIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :stripe_charge_id, :string
    add_column :orders, :last4, :string
  end
end
