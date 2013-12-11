require "test_helper"

class RefundWorkerTest < ActiveSupport::TestCase
  def setup
    FactoryGirl.create(:user, :stripe_connect)
    @user_id = "acct_1phxjZEuOipGrP93mEuq"
  end

  test "full refund from stripe web console" do
    Sidekiq::Testing.inline! do
      order = FactoryGirl.create(:order, :charged, id: "d056fcf1-fa58-4cef-bb77-bbbe366b9f57")
      event_id = "evt_2yUtOiQrkdoudf"
      refund = RefundWorker.new
      processed_order = VCR.use_cassette('stripe_web.refund_full') do
        refund.perform(event_id, @user_id)
      end
      assert processed_order.stripe_event_cancelled?, "stripe event not updated"
    end
  end

  test "handles part refund from stripe web console" do
     Sidekiq::Testing.inline! do
      order = FactoryGirl.create(:order, :charged, id: "ed14eade-5c77-419d-acf7-79878f95ba7f")
      event_id = "evt_2yVZPXzHMYbTMD"
      refund = RefundWorker.new
      processed_order = VCR.use_cassette('stripe_web.refund_part') do
        refund.perform(event_id, @user_id)
      end
      assert_equal processed_order.part_refund, 10.00, "part refund not processed"
    end
  end

  test "handles further refund from stripe web console" do
     Sidekiq::Testing.inline! do
      order = FactoryGirl.create(:order, :charged, id: "ed14eade-5c77-419d-acf7-79878f95ba7f")
      event_id = "evt_2yViwB35FP7CXF"
      refund = RefundWorker.new
      processed_order = VCR.use_cassette('stripe_web.refund_further') do
        refund.perform(event_id, @user_id)
      end
      assert_equal processed_order.part_refund, 20.00, "further refund not processed"
    end
  end
end