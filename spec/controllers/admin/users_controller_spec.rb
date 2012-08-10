require 'spec_helper'

describe Admin::UsersController do
  let(:user) { create_user! }

  context "standard users" do
    before do
      sign_in(:user, user)
    end
    
    it "are able to access the index action" do
      get 'index'
      response.should render_template("index")
     # flash[:alert].should eql("You must be an admin to do that.")
    end


    it "are not able to access the new action" do
      get 'new'
      response.should redirect_to(root_path)
      flash[:alert].should eql("You must be an admin to do that.")
    end
  end
end
