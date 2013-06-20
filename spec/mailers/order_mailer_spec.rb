require "spec_helper"

describe OrderMailer do
  describe "event_deferred" do
    let(:order) { create(:order)}
    let(:mail) { OrderMailer.event_deferred(order) }

    it "renders the headers" do
      mail.subject.should eq("Event deferred")
      mail.to.should eq([order.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Your Event has been Deferred")
    end
  end

end
