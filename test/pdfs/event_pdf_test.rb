require 'test_helper'

class EventPdfTest < ActiveSupport::TestCase
  def setup
    @event = FactoryGirl.create(:event, name: "Tester")
    @orders = FactoryGirl.create_list(:order, 5, event: @event)
    @tickets = FactoryGirl.create_list(:ticket, 5)
  end

  test "event order pdf generation works" do
    pdf = EventPdf.new(@event, @orders)
    reader = PDF::Reader.new(StringIO.new(pdf.render))
    page = reader.page(1)
    assert page.to_s.include?(@event.name), "should have name"
    assert page.to_s.include?(@event.date.strftime("%b %d %Y")), "should have date"
    assert page.to_s.include?(@event.location), "should have date"
    assert page.to_s =~ /Total Orders: 5/i, "should have order count"
    assert page.to_s.include?(@orders.first.name), "should have order name"
    assert page.to_s.include?(@orders.first.quantity.to_s), "should have order quantity"
  end

  test "event ticket pdf generation works" do
    pdf = TicketsPdf.new(@event, @tickets)
    reader = PDF::Reader.new(StringIO.new(pdf.render))
    page = reader.page(1)
    assert page.to_s.include?("#{@event.date.strftime("%b %d %Y")} in #{@event.location}"), "header not printing"
    assert page.to_s.include?(@tickets.first.order.name), "should have order name"
    assert page.to_s.include?(@tickets.first.order.email), "should have order email"
    assert page.to_s.include?(@tickets.first.number), "should have ticket number"
  end
end
