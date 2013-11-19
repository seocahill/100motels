require "test_helper"

class ChargesWorkerTest < ActiveSupport::TestCase
  def setup
    @event = FactoryGirl.create(:event, :live_event)
    @order = FactoryGirl.create(:order, event: @event)
  end

  test "processes valid cards properly" do
    Sidekiq::Testing.inline! do
      charge = ChargesWorker.new
      processed_order = VCR.use_cassette('charge_customer_worker') do
        charge.perform(@order.id, @event.user.api_key)
      end
      # assert Sidekiq::Testing.inline?
      assert processed_order.stripe_event_charged?, "stripe event not updated"
      assert_equal processed_order.stripe_charge_id, "ch_2yB1hNwlZpxX5X", "charge_id not set"
    end
  end
end