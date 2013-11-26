require 'test_helper'

class EventPdfTest < ActiveSupport::TestCase
  def setup
    @event = FactoryGirl.create(:event)
    @orders = FactoryGirl.create_list(:order, 5, event: @event)
    @tickets = FactoryGirl.create_list(:ticket, 5)
  end

  test "event order pdf generation works" do
    pdf = EventPdf.new(@event, @orders)
    reader = PDF::Reader.new(StringIO.new(pdf.render))
    page = reader.page(1)
    skip "need to figure out how to test matching contents of pdf"
  end

  test "event ticket pdf generation works" do
    pdf = TicketsPdf.new(@event, @tickets)
    skip
  end
end