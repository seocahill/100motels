require 'spec_helper'

describe Event do

  subject(:event) { FactoryGirl.create(:event, :with_user, ticket_price: 7) }

  it "has a valid factory" do
    FactoryGirl.create(:event).should be_valid
  end

  it { should respond_to(:artist) }
  it { should respond_to(:venue) }
  it { should respond_to(:date) }
  it { should respond_to(:doors) }
  it { should respond_to(:ticket_price) }
  it { should be_valid }


  #relations

  its(:ticket_price) { should == 7 }

  it "is invalid without an artist" do
    FactoryGirl.build(:event, :invalid).should_not be_valid
  end

  it "Doorman returns ticket availibility, proplerly formatted" do
    User.stub(:checkedin_count).with(event.venue).and_return(23)
    event.sold_out.should == "There are 23 tickets left on the door"
  end

end