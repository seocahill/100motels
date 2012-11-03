class AddCustomerDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customer_details, :hstore
  end
end
