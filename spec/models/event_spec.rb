require 'spec_helper'

describe "event" do
  
  it "has a valid factory" do
    FactoryGirl.create(:event).should be_valid
  end
  
  it "is invalid without an artist" do
    FactoryGirl.build(:event, artist: nil).should_not be_valid
  end
  
  it "is invalid without a venue" do
    FactoryGirl.build(:event, venue: nil).should_not be_valid
  end
  
  it "is invalid without a date"
  
  it "is invalid without a ticket price"
end