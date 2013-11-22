require 'test_helper'
require 'stripe_mock'

class WebhookHandlerTest < ActiveSupport::TestCase

  def setup
    StripeMock.start
  end

  def teardown
    StripeMock.stop
  end

  test "passes charge.refunded event to worker queue" do
    event = StripeMock.mock_webhook_event('charge.refunded')
    handler = WebhookHandlerService.new(event)
    assert_equal 0, RefundWorker.jobs.size
    handler.cancel_orders
    assert_equal 1, RefundWorker.jobs.size
  end

  test "is doesnt pass incorrect event to worker" do
    event = StripeMock.mock_webhook_event('charge.succeeded')
    handler = WebhookHandlerService.new(event)
    handler.cancel_orders
    assert_equal 0, RefundWorker.jobs.size
  end
end
