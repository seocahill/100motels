class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :auth_token
      t.string :password_digest
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.string :confirmation_token
      t.datetime :confirmation_sent_at
      t.string :api_key
      t.integer :state, limit: 4, default: 0

      t.timestamps
    end
    add_index :users, :auth_token
    add_index :users, :email
  end
end
