require 'spec_helper'
# include PgSearch

describe Event do

  subject(:event) { FactoryGirl.create(:event, artist: "Crete Boom", venue: "Hideout",
                                       title: "Three Ring Circus ", new_location: "Galway",
                                       about: "living hell town music", date: Date.parse("31-12-2020")) }

  it "has a valid factory" do
    create(:event).should be_valid
  end

  it "should have an organizer" do
   expect(event.event_users.first.state_organizer?).to be_true
  end

  it "should be owned by a user" do
    expect(event.event_users.first.user.profile).to eq MemberProfile.last
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


  describe ".text_search" do
    context "query present and matches exising record" do
      it 'searches artist' do
        expect(Event.text_search("Crete Boom")).to include event
      end
      it 'searches venue' do
        expect(Event.text_search("Hideout")).to include event
      end
      it 'searches title' do
        expect(Event.text_search("Three Ring Circus")).to include event
      end
      it 'searches about' do
        expect(Event.text_search("living hell town music")).to include event
      end
      it 'searches location' do
        expect(Event.text_search("Galway")).to include event
      end
    end

    context "query has no matches" do
      it 'searches artist' do
        expect(Event.text_search("Frete Doom")).to be_empty
      end
      it 'searches venue' do
        expect(Event.text_search("Ballina Ballroom")).to be_empty
      end
      it 'searches title' do
        expect(Event.text_search("Whats tha craic")).to be_empty
      end
      it 'searches about' do
        expect(Event.text_search("shams stick together")).to be_empty
      end
      it 'searches location' do
        expect(Event.text_search("Ballina, Mayo")).to be_empty
      end
    end

    context "query not present" do
      it 'should return all records' do
        expect(Event.text_search("")).to include event
      end
    end
  end

  describe '#forbid_date_change' do
    context 'orders present and member' do
      it 'should raise a validation error' do
        event.stub(:orders, :present?).and_return(true)
        event.stub(state_member?: true)
        event.date = 1.year.from_now
        expect {event.save!}.to raise_error(ActiveRecord::RecordInvalid, /can't change the date of an active event!/)
      end
    end
    context 'order present' do
      it 'should change the date' do
        event.stub(:orders, :present?).and_return(true)
        expect{event.date = 1.year.from_now}.to change(event, :date)
      end
    end
    context 'member present' do
      it 'should change the date' do
        event.stub(:state_member?).and_return(true)
        expect{event.date = 1.year.from_now}.to change(event, :date)
      end
    end
  end
end