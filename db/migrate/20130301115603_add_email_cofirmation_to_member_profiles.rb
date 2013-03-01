class AddEmailCofirmationToMemberProfiles < ActiveRecord::Migration
  def change
    add_column :member_profiles, :email_confirm_token, :string
    add_index :member_profiles, :email_confirm_token
    add_column :member_profiles, :email_confirm_sent_at, :datetime
  end
end
