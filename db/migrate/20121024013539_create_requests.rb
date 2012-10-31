class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :profile_id
      t.references :user
      t.references :event
      t.integer :state, default: 0, limit: 6

      t.timestamps
    end
    add_index :requests, :profile_id
    add_index :requests, :user_id
    add_index :requests, :event_id
  end
end
