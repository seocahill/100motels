require 'spec_helper'

describe Event do

  subject(:event) { FactoryGirl.create(:event) }

  it "has a valid factory" do
    create(:event).should be_valid
  end

  it { should respond_to(:artist) }
  it { should respond_to(:venue) }
  it { should respond_to(:date) }
  it { should respond_to(:doors) }
  it { should respond_to(:ticket_price) }
  it { should be_valid }

  it "is invalid without an artist" do
    build(:event, artist: nil).should_not be_valid
  end

  it "should have an orgnaizer" do
   expect(event.event_users.first.state_organizer?).to be_true
  end

  it "should be owned by a user" do
    expect(event.event_users.first.user.profile).to eq MemberProfile.last
  end
end