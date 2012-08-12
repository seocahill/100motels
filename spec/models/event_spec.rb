require 'spec_helper'

describe Event do
  
  let(:event) { FactoryGirl.create(:event, ticket_price: 7) }

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
  
  it "Doorman returns ticket availibility, proplerly formatted" do
    User.stub(:checkedin_count).with(event.venue).and_return(23)
    event.sold_out.should == "There are 23 tickets left on the door"
  end

end