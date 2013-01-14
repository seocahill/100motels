class AddStateAndApiKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :state, :integer, limit: 8, default: 0
    add_column :users, :encrypted_api_key, :string
  end
end
