require 'spec_helper'

describe "Authentication" do
  let(:auth) { Authentication.new }
  describe "#user" do
    context 'user present' do
      let(:user) { double('User') }
      it "should find the user" do
        auth.stub!(:user_with_password).and_return(user)
        expect(auth.user).to eq user
      end
    end
    context 'user not found' do
      it "should find the user" do
        auth.stub!(:user_with_password).and_return(nil)
        expect(auth.user).to be_nil
      end
    end
  end

  describe "#authenticated?" do
    context "user is suspended" do
      let(:mock_user) { double('User', state_suspended?: true) }
      it "should return false" do
        auth.stub(:user).and_return(mock_user)
        expect(auth.authenticated?).to be_false
      end
    end
    context "user is not suspended" do
      let(:mock_user) { double('User', state_suspended?: false) }
      it "should return true" do
        auth.stub(:user).and_return(mock_user)
        expect(auth.authenticated?).to be_true
      end
    end
  end
end