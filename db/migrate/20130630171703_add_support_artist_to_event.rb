class AddSupportArtistToEvent < ActiveRecord::Migration
  def change
    add_column :events, :first_support, :string
    add_column :events, :second_support, :string
    add_column :events, :third_support, :string
  end
end
