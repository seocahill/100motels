require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase

  def setup
    @event = FactoryGirl.create(:event)
    @orders = FactoryGirl.create_pair(:order, event: @event)
    @message = FactoryGirl.build(:message, :defer)
  end

  test "event_deferred" do
    email = OrderMailer.event_deferred(@event.id, @message).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['seo@100motels.com'], email.from
    assert_equal Order.pluck(:email) | email.bcc, Order.pluck(:email)
    assert_equal '100 Motels - Event Deferred', email.subject
    assert_match "Here's an update about your event", email.body.to_s
    assert_match "December 31, 2014", email.body.to_s
  end

end