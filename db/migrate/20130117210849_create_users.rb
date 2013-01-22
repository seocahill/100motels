class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :profile_id
      t.string :profile_type
      t.string :auth_token
      t.string :encrypted_api_key

      t.timestamps
    end
    add_index :users, :profile_id
    add_index :users, :profile_type
    add_index :users, :auth_token
  end
end
