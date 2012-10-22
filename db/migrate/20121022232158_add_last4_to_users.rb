class AddLast4ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last4, :integer
    add_column :users, :media, :string
    add_column :users, :media_html, :string
  end
end
