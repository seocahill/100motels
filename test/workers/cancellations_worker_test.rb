require "test_helper"

class CancellationsWorkerTest < ActiveSupport::TestCase
  def setup
    @event = FactoryGirl.create(:event, :live_event)
  end

  test "refunds pending orders" do
    Sidekiq::Testing.inline! do
      order = FactoryGirl.create(:order, event: @event)
      refund = CancellationsWorker.new
      processed_order = refund.perform(order.id, @event.user.api_key)
      assert_equal processed_order.stripe_event, "cancelled", "stripe event not updated"
    end
  end

  test "handles charged orders" do
    Sidekiq::Testing.inline! do
      order = FactoryGirl.create(:order, :charged, event: @event)
      refund = CancellationsWorker.new
      processed_order = VCR.use_cassette('charge.refund') do
        refund.perform(order.id, @event.user.api_key)
      end
      assert_equal processed_order.stripe_event, "cancelled", "stripe event not updated"
    end
  end
end
