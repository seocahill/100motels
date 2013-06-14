require 'spec_helper'

describe Event do

  subject(:event) { FactoryGirl.create(:event) }

  it "has a valid factory" do
    create(:event).should be_valid
  end

  it {should have_many :orders}
  it {should have_many :tickets}
  it {should have_many :event_users}
  it {should have_many :users}
  it {should belong_to :location}

  it { should respond_to(:artist) }
  it { should respond_to(:date) }
  it { should respond_to(:doors) }
  it { should respond_to(:venue) }
  it { should respond_to(:capacity) }
  it { should respond_to(:ticket_price) }
  it { should respond_to(:title) }
  it { should respond_to(:music) }
  it { should respond_to(:video) }
  it { should respond_to(:about) }
  it { should respond_to(:image) }
  it { should respond_to(:target) }
  it { should respond_to(:new_location) }
  it { should respond_to(:visible) }
  it { should respond_to(:state) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:artist) }
  it { should validate_presence_of(:venue) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:doors) }
  it { should ensure_length_of(:artist).is_at_most(75) }
  it { should ensure_length_of(:title).is_at_most(30) }
  it { should validate_numericality_of(:capacity).with_message("^Max capacity is 200 during beta") }
  it { should validate_numericality_of(:target) }
  it { should validate_numericality_of(:ticket_price).with_message("^Price must be in the range $10-$20 during beta") }


  it "should have an orgnaizer" do
   expect(event.event_users.first.state_organizer?).to be_true
  end

  it "should be owned by a user" do
    expect(event.event_users.first.user.profile).to eq MemberProfile.last
  end
end