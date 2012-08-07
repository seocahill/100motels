Given /^there are the following users:$/ do |table| 
  save_and_open_page
  table.hashes.each do |attributes|
    confirm_user = attributes.delete("confirm_user") 
    @user = User.create!(attributes.merge!( :password_confirmation => attributes[:password]))
    
    if( confirm_user == "true" )
      @user.confirm!
    end
  end
end
