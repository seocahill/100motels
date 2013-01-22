class AddAttibsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :capacity, :integer
    add_column :events, :target, :integer
    add_column :events, :about, :text
    add_column :events, :about_html, :text
    add_column :events, :video, :string
    add_column :events, :video_html, :string
    add_column :events, :music, :string
    add_column :events, :music_html, :string
    add_column :events, :image, :string
    add_column :events, :image_html, :string
  end
end
