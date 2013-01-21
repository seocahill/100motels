class AddChargeDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_customer_id, :string
    add_column :users, :card_type, :string
    add_column :users, :exp_year, :string
    add_column :users, :exp_month, :string
    add_column :users, :last4, :string
    add_column :users, :cvc_check, :string
    add_column :users, :country, :string
  end
end
