require 'spec_helper'

describe Order do
  subject(:order) {create(:order)}

  context "#cancel_order" do
    it "should change the orders state to cancelled" do
      OrderMailer.stub(:order_cancelled)
      order.cancel_order
      expect(order.stripe_event_cancelled?).to be_true
    end
  end

end
