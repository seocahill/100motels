class AddUserIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :user_id, :integer
  end
  add_index :orders, :user_id
end
