require 'test_helper'

class CustomerOrderTest < ActiveSupport::TestCase

  def setup
    @event = FactoryGirl.create(:event, :live_event)
    @orders = FactoryGirl.create_pair(:order, event: @event)
  end

  test "process adds jobs to worker queue" do
    assert_equal 0, ChargesWorker.jobs.size
    ChargeCustomer.new(@event).process
    assert_equal 2, ChargesWorker.jobs.size
  end
end