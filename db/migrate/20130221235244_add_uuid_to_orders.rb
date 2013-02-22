class AddUuidToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :uuid, :string, uniqueness: :true
    add_index :orders, :uuid
  end
end
