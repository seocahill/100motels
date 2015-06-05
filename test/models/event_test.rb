require 'test_helper'

class EventTest < ActiveSupport::TestCase
  should belong_to(:user)
  should have_many(:orders)
  should have_many(:tickets).through(:orders)
  should ensure_length_of(:name).is_at_most(50)
  should validate_presence_of(:name)
  should validate_presence_of(:date)
  should validate_presence_of(:time)
  should validate_numericality_of(:ticket_price)
  .with_message(/leave blank for free events or between 5 and 50 dollars for paid events./)


  test 'validate ticket numericality low limit' do
    event = FactoryGirl.build(:event, ticket_price: rand(0.1..4.9))
    refute event.save
  end

  test 'validate ticket numericality high limit' do
    event = FactoryGirl.build(:event, ticket_price: rand(51..100000))
    refute event.save
  end

  test 'validate ticket numericality allow 0' do
    event = FactoryGirl.build(:event, ticket_price: nil)
    assert event.save
  end

  test 'validate forbid date_change on update' do
    order = FactoryGirl.create(:order)
    assert_raise ActiveRecord::RecordInvalid do
      order.event.update_attributes!(date: Date.today)
    end
  end

  test 'validate forbid visible on update' do
    order = FactoryGirl.create(:order)
    assert_raise ActiveRecord::RecordInvalid do
      order.event.update_attributes!(location: "England")
    end
  end

  test 'allow update on Date and Location if orders not present' do
    event = FactoryGirl.create(:event)
    assert event.update_attributes(date: Date.today, location: "London, Uk")
  end

  test 'forbid change visible for unconfirmed users' do
    user = FactoryGirl.create(:user, state: :unconfirmed)
    event = FactoryGirl.create(:event, user: user)
    assert_raise ActiveRecord::RecordInvalid do
      event.update_attributes!(visible: true)
    end
  end

  test "Event Factory should be valid" do
    event = FactoryGirl.build(:event)
    assert event.valid?
  end

  test "self.text_search name" do
    events = FactoryGirl.create_pair(:event)
    events.first.update_attributes(name: "seotime")
    search = Event.text_search("seotime")
    assert_equal search.count(:all), 1
  end

  test "self.text_search location" do
    events = FactoryGirl.create_pair(:event)
    events.first.update_attributes(name: "Ballina")
    search = Event.text_search("Ballina")
    assert_equal search.count(:all), 1
  end

  test "self.text_search about" do
    events = FactoryGirl.create_pair(:event)
    events.first.update_attributes(about: "The Magical Tour")
    search = Event.text_search("Magical")
    assert_equal search.count(:all), 1
  end

  test "self.text_seach returns all if unfound" do
    events = FactoryGirl.create_pair(:event)
    assert_equal Event.text_search("").count(:all), 2
  end

  test "auto_html html_escape" do
    event = FactoryGirl.build(:event, about: "<script>alert(0)</script>")
    assert_equal "<p>&lt;script&gt;alert(0)&lt;/script&gt;</p>\n", event.about_html
  end

  test "auto_html redcarpet" do
    event = FactoryGirl.build(:event, about: "This is **my** text.")
    assert_equal "<p>This is <strong>my</strong> text.</p>\n", event.about_html
  end

  test "auto_html soundcloud" do
    event = FactoryGirl.build(:event, about: 'https://soundcloud.com/creteboom/sets/them-bones-need-oxygen')
    assert event.about_html.scan('<iframe width="100%" height="450" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?"></iframe>')
  end

  test "auto_html link transform" do
    event = FactoryGirl.build(:event, about: "http://vukajlija.com")
    assert_equal '<p><a href="http://vukajlija.com" target="_blank" rel="nofollow">http://vukajlija.com</a></p>'+"\n", event.about_html
  end

end
