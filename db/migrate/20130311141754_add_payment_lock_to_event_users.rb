class AddPaymentLockToEventUsers < ActiveRecord::Migration
  def change
    add_column :event_users, :payment_lock, :boolean, default: true
  end
end
