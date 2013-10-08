class AddAttibsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :about, :text
    add_column :events, :about_html, :text
    add_column :events, :image, :string
  end
end
