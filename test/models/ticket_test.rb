require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  should belong_to(:order)
end
