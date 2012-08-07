require 'spec_helper'

  describe EventsController do
  let(:user) do 
    user = FactoryGirl.create(:user)
    user.confirm!
    user
  end

  context 'standard users' do
    it "cannot access the new action" do
      sign_in(:user, user)
      response.should redirect_to(root_path)
      flash[:alert].should eql("You must be an admin to do that.")
    end
  end

    it "displays an error message for a missing event" do
    get :show, :id => 'not here'
    response.should redirect_to(events_path)
    message = "The event you were looking for could not be found"
    flash[:alert].should eql(message)
  end
end
