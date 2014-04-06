class AddStripeDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_data, :json
  end
end
