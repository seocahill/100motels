include "test_helper"
require "minitest/rails/capybara"

class EventDecoratorTest < Draper::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event)
    sign_in(@event.user)
  end

  test "event_owner?" do


end