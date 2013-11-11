class AddPartRefundToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :part_refund, :decimal, default: 0.0, null: false
  end
end
