class AddConfirmedToUser < ActiveRecord::Migration
  def change
    add_column :users, :confirmed, :datetime
  end
end
