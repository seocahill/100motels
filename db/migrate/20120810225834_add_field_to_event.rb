class AddFieldToEvent < ActiveRecord::Migration
  def change
    add_column :events, :ticket_price, :decimal, :precision => 8 , :scale => 2
  end
end
