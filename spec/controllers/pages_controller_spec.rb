require 'spec_helper'

describe PagesController do

describe "GET #home" do
  it "populates an array of events" do
    event = FactoryGirl.create(:event)
    get :home
    assigns(:events).should eq([event])
  end

  it "populates an array of users" do
    user = FactoryGirl.create(:user)
    get :home
    assigns(:users).should eq([user])
  end
  
  it "renders the :home view" do
    get :home
    response.should render_template :home
  end
end

end
