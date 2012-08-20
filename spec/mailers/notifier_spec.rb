require "spec_helper"

describe Notifier do
  describe "order_processed" do
    let(:mail) { Notifier.order_processed }

    it "renders the headers" do
      mail.subject.should eq("Order processed")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
