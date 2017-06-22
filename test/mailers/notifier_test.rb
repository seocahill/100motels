require 'test_helper'

class NotifierTest < ActionMailer::TestCase

  def setup
    @event = FactoryGirl.create(:event)
    FactoryGirl.create_pair(:order, event: @event)
    @order_ids = Order.pluck(:id)
    @message = FactoryGirl.build(:message)
  end

  test "event_cancelled" do
    email = Notifier.event_cancelled(@order_ids, @message).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['seo@100motels.com'], email.from
    assert_equal Order.pluck(:email) | email.to, Order.pluck(:email)
    assert_equal 'Your event has been cancelled', email.subject
    assert_match "Here's an update about your event", email.body.to_s
  end

  test "group_message" do
    email = Notifier.group_message(@event.id, @message).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['seo@100motels.com'], email.from
    assert_equal Order.pluck(:email) || email.to, Order.pluck(:email)
    assert_equal "A message about your Event", email.subject
    assert_match "Here's an update about your event", email.body.to_s
  end
end