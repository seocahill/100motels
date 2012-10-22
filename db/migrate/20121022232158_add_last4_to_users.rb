class AddLast4ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last4, :integer
  end
end
