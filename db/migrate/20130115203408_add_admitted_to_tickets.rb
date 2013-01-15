class AddAdmittedToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :admitted, :datetime
  end
end
