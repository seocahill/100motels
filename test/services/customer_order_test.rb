require 'test_helper'
require 'stripe_mock'

class CustomerOrderTest < ActiveSupport::TestCase

  def setup
    StripeMock.start
    @order_in_progress = FactoryGirl.build(:order, :in_progress)
    @order = FactoryGirl.build(:order, ticket_price: 10.0, quantity: 1)
    @token = StripeMock.generate_card_token(last4: "9191", exp_year: 2015, name: "Seo Cahill")
  end

  def teardown
    StripeMock.stop
  end

  test "total_inc_fees returns expected result" do
    new_customer = CustomerOrder.new(@order, @token)
    assert_equal new_customer.total_inc_fees, 11.06
  end

  test "create_customer" do
    new_customer = CustomerOrder.new(@order, @token).create_customer
    assert_equal new_customer.email, @order.email
  end

  test "add_customer_details_to_order" do
    new_customer = CustomerOrder.new(@order_in_progress, @token)
    customer = new_customer.create_customer
    new_customer.add_customer_details_to_order(customer)
    assert @order_in_progress.stripe_customer_token.present?, "customer id not set"
    assert_equal @order_in_progress.name, "Seo Cahill", "name not set"
    assert_equal @order_in_progress.last4, "9191", "last4 not set"
    assert_equal @order_in_progress.ticket_price, 10.0, "ticket price not set"
    assert @order_in_progress.total > 0.0 , "total price not set"
  end

  test "process_order success" do
    assert_equal CustomerOrder.new(@order_in_progress, @token).process_order, true
  end

end
