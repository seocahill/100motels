require 'test_helper'

class CustomerOrderTest < ActiveSupport::TestCase

  test "process adds jobs to worker queue" do
    event = FactoryGirl.create(:event, :live_event)
    orders = FactoryGirl.create_pair(:order, event: event)
    assert_equal 0, ChargesWorker.jobs.size
    ChargeCustomer.new(event).process
    assert_equal 2, ChargesWorker.jobs.size
  end
end