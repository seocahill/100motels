class AddStripeUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_uid, :string
  end
end
