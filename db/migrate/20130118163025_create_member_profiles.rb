class CreateMemberProfiles < ActiveRecord::Migration
  def change
    create_table :member_profiles do |t|
      t.string :name
      t.string :avatar
      t.string :email
      t.string :password_digest
      t.string :auth_token
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.string :confirmation_token
      t.datetime :confirmation_sent_at

      t.timestamps
    end
    add_index :member_profiles, :email
    add_index :member_profiles, :auth_token
  end
end
