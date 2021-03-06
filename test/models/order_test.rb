require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should belong_to(:event)
  should have_many(:tickets)
  should validate_numericality_of(:quantity)

  test 'Order Factory' do
    assert FactoryGirl.build(:order).valid?
  end

  test "self.text_search name" do
    orders = FactoryGirl.create_pair(:order)
    orders.first.update_attributes(name: "seotime")
    search = Order.text_search("seotime")
    assert_equal search.count(:all), 1
  end

  test "self.text_search location" do
    orders = FactoryGirl.create_pair(:order)
    orders.first.update_attributes(email: "seo@time.com")
    search = Order.text_search("seo@time.com")
    assert_equal search.count(:all), 1
  end

  test "self.text_search about" do
    orders = FactoryGirl.create_pair(:order)
    search = Order.text_search(orders.first.id)
    assert_equal search.count(:all), 1
  end

  test "self.text_seach returns all if unfound" do
    orders = FactoryGirl.create_pair(:order)
    assert_equal Order.text_search("").count(:all), 2
  end

  test "self.text_search event relation name" do
    orders = FactoryGirl.create_pair(:order)
    search = Order.text_search(orders.first.event.name)
    assert_equal search.count(:all), 1
  end

  test "self.text_search event relation location" do
    orders = FactoryGirl.create_pair(:order)
    search = Order.text_search(orders.first.event.location)
    assert_equal search.count(:all), 1
  end

  test "self.text_search ticket relation number" do
    order = FactoryGirl.create(:order)
    FactoryGirl.create(:order)
    ticket = order.tickets.first
    search = Order.text_search(ticket.number)
    assert_equal search.count(:all), 1
  end

  test "state scopes" do
    orders = FactoryGirl.create_pair(:order)
    orders.first.update_attributes(stripe_event: :cancelled)
    assert_equal Order.pending.count(:all), 1, "Pending scope error"
    assert_equal Order.not_cancelled.count(:all), 1, "Not cancelled scope error"
  end
end
