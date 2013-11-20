require "test_helper"

class RefundWorkerTest < ActiveSupport::TestCase
  def setup
    FactoryGirl.create(:user, :stripe_connect)
    @event_id = "evt_2yMEml0h62cLGo"
    @user_id = "acct_1phxjZEuOipGrP93mEuq"
    @order = FactoryGirl.create(:order, :charged)
  end

  test "full refund from stripe web console" do
    Sidekiq::Testing.inline! do
      refund = RefundWorker.new
      processed_order = VCR.use_cassette('stripe_web.refund_full') do
        refund.perform(@event_id, @user_id)
      end
      assert processed_order.stripe_event_cancelled?, "stripe event not updated"
    end
  end

  test "handles part refrund from stripe web console" do
    skip 'part refund'
  end
end