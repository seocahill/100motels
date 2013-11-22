require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  should belong_to(:order)

  test 'Ticket Factory' do
    assert FactoryGirl.build(:ticket).valid?
  end

end