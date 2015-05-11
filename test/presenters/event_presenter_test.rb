require "test_helper"

class EventPresenterTest < ActionView::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event, id: 6, image: "https://www.myimage.com/something.jpg")
    FactoryGirl.create_pair(:order, event: @event, quantity: 2, ticket_price: 10.0)
    @presenter = EventPresenter.new(view)
  end

  test "stub event_owner?" do
    @presenter.stub(:event_owner?, true) do
      assert @presenter.event_owner?(@event), "stub sanity ok"
    end
  end

 test "filepicker presenter" do
  skip
    @presenter.stub(:event_owner?, true) do
      assert_match @presenter.filepicker(@event), '<form accept-charset="UTF-8" action="/events/6" class="edit_event" id="edit_event_6" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="_method" type="hidden" value="patch" /></div><input data-fp-apikey="Aw7pyep7aSfmtPLfI_3jYz" data-fp-button-class="btn btn-default btn-lg" data-fp-button-text="&lt;i class=&quot;fa fa-picture-o&quot;&gt;&lt;/i&gt;" data-fp-services="COMPUTER, IMAGE_SEARCH, INSTAGRAM, URL, FLICKR" id="event_image" name="event[image]" onchange="this.form.submit();" type="filepicker" value="https://www.myimage.com/something.jpg" /></form>', "filepicker button not generated"
    end
  end

  test "image presenter no image" do
    assert_nil EventPresenter.new(view).image(FactoryGirl.build(:event, image: nil))
  end

  test "image presenter has image" do
    assert_match @presenter.image(@event), "https://www.myimage.com/something.jpg"
  end

  test "ticket sold" do
    assert_equal @presenter.tickets_sold(@event), 4, "wrong sale figure"
  end

  test "ticket left should be 50" do
    @presenter.stub(:tickets_sold, 50) do
      assert_equal @presenter.tickets_left(@event), 50
    end
  end

  test "no tickets left" do
    @presenter.stub(:tickets_sold, 101) do
      assert_equal @presenter.tickets_left(@event), "sold out"
    end
  end

  test "per cent sold" do(@event)
    @presenter.stub(:tickets_sold, 50) do
      assert_equal @presenter.per_cent_sold(@event), 50
    end
  end

  test "100% per cent sold" do
    @presenter.stub(:tickets_sold, 101) do
      assert_equal @presenter.per_cent_sold(@event), 100
    end
  end

  test "left_to_go left" do
    assert_equal @presenter.left_to_go(@event), "3 months", "wrong time returned"
  end

  test "no time left" do
    assert_equal EventPresenter.new(view).left_to_go(FactoryGirl.build(:event, date: "31-12-2008")), "No time", "should return no time"
  end

  test "visible" do
    assert_equal @presenter.is_visible(@event), content_tag(:span, "visible", class: "label label-success")
  end

  test "earnings" do
    assert_equal @presenter.earnings(@event), "$40.00"
  end

  test "on sale?" do
    assert_equal @presenter.on_sale?(@event), true
  end

  test "not on sale" do
    assert_equal EventPresenter.new(view).on_sale?(FactoryGirl.build(:event, date: "31-12-2008")), false, "should return false"
  end

  test "overall target" do
    skip 'how to mock'
    view.expect(:current_user, @event.user) do
      FactoryGirl.create(:order, event: @event, quantity: 5)
      assert_equal EventPresenter.new(view).overall_target, 20, "not correct %"
    end
  end

  test "user doesnt own event but is superadmin" do
    def view.current_user; FactoryGirl.create(:user, state: :superadmin); end
    assert EventPresenter.new(view).event_owner?(@event), "should be true for admin"
  end

  test "user doesnt own event" do
    def view.current_user; FactoryGirl.create(:user); end
    refute EventPresenter.new(view).event_owner?(@event), "should not be true for ordinary user"
  end

 end
