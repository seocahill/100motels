class AddTargetToEvents < ActiveRecord::Migration
  def change
    add_column :events, :target, :integer, null: false, default: 100
  end
end
