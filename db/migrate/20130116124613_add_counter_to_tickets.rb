class AddCounterToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :quantity_counter, :integer
  end
end
