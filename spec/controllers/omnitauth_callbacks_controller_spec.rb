require 'spec_helper'

describe OmniauthCallbacksController do

  context '#all' do
    it "should set the users stripe api key" do
      user = double('User', connect: true, api_key: "token")
      ApplicationController.any_instance.stub(current_user: user)
      get :all
      expect(response.status).to eq(302)
    end
  end

end