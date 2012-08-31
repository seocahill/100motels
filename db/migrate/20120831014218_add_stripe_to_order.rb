class AddStripeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :total, :decimal
    add_column :orders, :stripe_customer_token, :string
    add_column :orders, :plan, :string
  end
end
