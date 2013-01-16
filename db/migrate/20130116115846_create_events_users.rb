class CreateEventsUsers < ActiveRecord::Migration
  def change
    create_table :events_users do |t|
      t.references :event
      t.references :user
      t.integer :state, default: 0, limit: 3

      t.timestamps
    end
    add_index :events_users, :event_id
    add_index :events_users, :user_id
  end
end
