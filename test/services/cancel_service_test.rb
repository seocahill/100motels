require 'test_helper'

class CancelServiceTest < ActiveSupport::TestCase

  def setup
    @event = FactoryGirl.create(:event, :live_event)
    @orders = FactoryGirl.create_pair(:order, event: @event)
    @message = FactoryGirl.build(:message)
  end

  test "process adds not cancelled orders to worker queue" do
    assert_equal 0, CancellationsWorker.jobs.size
    CancelService.new(@event, @message).cancel_orders
    assert_equal 2, CancellationsWorker.jobs.size
  end

  test "process doesnt add cancelled orders to worker queue" do
    FactoryGirl.create(:order, event: @event, stripe_event: :cancelled)
    assert_equal 3, @event.orders.count
    CancelService.new(@event, @message).cancel_orders
    assert_equal 2, CancellationsWorker.jobs.size
  end
end