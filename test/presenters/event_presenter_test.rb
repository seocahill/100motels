require "test_helper"

class EventPresenterTest < ActionView::TestCase

  before do
    @event = FactoryGirl.build(:event, :live_event)
    EventPresenter.stub(:current_user, view)
  end

  test "event_owner? should be false as no current_user" do
    assert @presenter.event_owner?
  end
end