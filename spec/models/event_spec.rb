require 'spec_helper'

describe Event do

  subject(:event) { FactoryGirl.create(:event) }

  it "has a valid factory" do
    FactoryGirl.create(:event).should be_valid
  end

  it { should respond_to(:artist) }
  it { should respond_to(:venue) }
  it { should respond_to(:date) }
  it { should respond_to(:doors) }
  it { should respond_to(:ticket_price) }
  it { should be_valid }

  it "is invalid without an artist" do
    FactoryGirl.build(:event, artist: nil).should_not be_valid
  end

end