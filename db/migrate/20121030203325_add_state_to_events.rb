class AddStateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :state, :integer, default: 0, limit: 6
  end
end
