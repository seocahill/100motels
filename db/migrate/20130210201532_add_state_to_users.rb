class AddStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :state, :integer, limit: 4, default: 0
  end
end
