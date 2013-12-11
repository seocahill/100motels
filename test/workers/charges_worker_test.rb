require "test_helper"

class ChargesWorkerTest < ActiveSupport::TestCase
  def setup
    @event = FactoryGirl.create(:event, :live_event)
  end

  test "processes valid cards properly" do
    Sidekiq::Testing.inline! do
      order = FactoryGirl.create(:order, event: @event)
      charge = ChargesWorker.new
      processed_order = VCR.use_cassette('charge_customer_worker') do
        charge.perform(order.id, @event.user.api_key)
      end
      assert processed_order.stripe_event_charged?, "stripe event not updated"
      assert_equal processed_order.stripe_charge_id, "ch_2yB1hNwlZpxX5X", "charge_id not set"
    end
  end

  test "handles card declined" do
    Sidekiq::Testing.inline! do
      order = FactoryGirl.create(:order, :declined, event: @event)
      charge = ChargesWorker.new
      processed_order = VCR.use_cassette('charge_card_declined') do
        charge.perform(order.id, @event.user.api_key)
      end
      assert processed_order.stripe_event_failed?, "stripe event not updated"
      assert_equal processed_order.stripe_charge_id, nil
    end
  end
end