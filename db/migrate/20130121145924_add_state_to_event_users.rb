class AddStateToEventUsers < ActiveRecord::Migration
  def change
    add_column :event_users, :state, :integer, default: 0, limit: 3
  end
end
