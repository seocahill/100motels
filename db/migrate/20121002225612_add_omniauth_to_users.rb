class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :public_key, :string
    add_column :users, :encrypted_api_key, :string
  end
end
