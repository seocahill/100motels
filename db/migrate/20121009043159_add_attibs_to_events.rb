class AddAttibsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :venue_capacity, :integer
    add_column :events, :target, :integer
    add_column :events, :about, :text
    add_column :events, :video, :string
    add_column :events, :music, :string
    add_column :events, :image, :string
  end
end
