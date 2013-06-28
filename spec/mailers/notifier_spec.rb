require "spec_helper"

describe Notifier do

  its "Factory should be valid" do
    expect(build(:message)).to be_valid
  end

  describe "group_message" do
    let(:message) { build(:message, email: "current@example.com")}
    let(:order) { create(:order)}
    let(:mail) { Notifier.group_message(message, order) }

    it "renders the headers" do
      mail.subject.should eq("Important!")
      mail.to.should eq([order.email])
      mail.from.should eq(["current@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Here's a message about your Event:")
    end
  end

  describe "private_message" do
    let(:message) { build(:message, email: "current@example.com")}
    let(:order) { create(:order)}
    let(:mail) { Notifier.private_message(message) }

    it "renders the headers" do
      mail.subject.should eq(message.subject)
      mail.to.should eq([message.organizer_email])
      mail.from.should eq([message.email])
    end

    it "renders the body" do
      mail.body.encoded.should match(message.content)
    end
  end
end
