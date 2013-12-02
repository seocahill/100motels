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
    @presenter.stub(:event_owner?, true) do
      assert @presenter.filepicker(@event) =~ /Change Image/i, "filepicker button not generated"
    end
  end

  test "image presenter no image" do
    assert_match EventPresenter.new(view).image(FactoryGirl.build(:event, image: nil)), "https://s3-us-west-2.amazonaws.com/onehundredmotels/247915_156305404435251_2616225_n.jpg"
  end

  test "image presenter has image" do
    assert_match @presenter.image(@event), "https://www.myimage.com/something.jpg"
  end

  test "index_image presenter no image" do
    assert_match EventPresenter.new(view).index_image(FactoryGirl.build(:event)), '<img alt="247915 156305404435251 2616225 n" height="200" src="https://s3-us-west-2.amazonaws.com/onehundredmotels/247915_156305404435251_2616225_n.jpg" width="380" />'
  end

  test "index_image presenter has image" do
    assert_match @presenter.index_image(@event), '<img alt="Convert?fit=crop&amp;h=200&amp;w=380" src="https://www.myimage.com/something.jpg/convert?fit=crop&amp;h=200&amp;w=380" />'
  end

  test "edit button if current_user" do
    @presenter.stub(:event_owner?, true) do
      assert_match @presenter.edit_button(@event), button_tag("Edit", type: "button", class: "btn btn-default edit-about", data: { toggle: "button" })
    end
  end

  test "about_section editable if current_user" do
    @presenter.stub(:event_owner?, true) do
      assert_match @presenter.about_section(@event)[0..32], "<span class='best_in_place about'"
    end
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

 end