class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user
      t.integer :request_id
      t.integer :state, default: 0, limit: 6

      t.timestamps
    end
    add_index :notifications, :request_id
    add_index :notifications, :user_id
  end
end
