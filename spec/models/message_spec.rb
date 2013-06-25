require 'spec_helper'

describe '#send_messages' do
  let(:event) { create(:event, :visible)}
  let(:message) { build(:message, event_id: event.id)}
  before(:each) { event.orders << create(:order)}

  it "should send group message to customers if event present" do
    message.send_messages
    last_email.body.encoded.should match(message.content)
  end
end