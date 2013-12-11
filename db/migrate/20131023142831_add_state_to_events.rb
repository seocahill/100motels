class AddStateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :state, :integer, null: false, default: 0
  end
end
