require 'spec_helper'

describe Event do
  
  it "has a valid factory" do
    FactoryGirl.create(:event).should be_valid
  end
  
  it { should respond_to(:artist) }

  #its(:artist) {should == "Crete Boom"}

  its(:ticket_price) { should == 7 }

  it "is invalid without an artist" do
    FactoryGirl.build(:event, artist: nil).should_not be_valid
  end
  
  it "is invalid without a venue" do
    FactoryGirl.build(:event, venue: nil).should_not be_valid
  end
  
  it "is invalid without a date" do
    FactoryGirl.build(:event, date: nil).should_not be_valid
  end
  
  it "is invalid without a price" do
    FactoryGirl.build(:event, ticket_price: nil).should_not be_valid
  end
  
end