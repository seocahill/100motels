require 'spec_helper'

describe User do
  
  subject(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:event) }

  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end
  
  it { should respond_to(:email) }
  it { should be_valid }

  #relations
  it { should have_many(:events) }
  
  it "admin should be valid" do
    FactoryGirl.build(:admin).should be_valid
  end
end
