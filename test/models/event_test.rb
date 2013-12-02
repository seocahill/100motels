require 'test_helper'

class EventTest < ActiveSupport::TestCase
  should belong_to(:user)
  should have_many(:orders)
  should have_many(:tickets).through(:orders)
  should ensure_length_of(:name).is_at_most(50)
  should validate_presence_of(:name)
  should validate_presence_of(:date)
  should validate_numericality_of(:ticket_price)
  .with_message(/leave blank for free events or between 5 and 50 dollars for paid events./)

  test 'enum_accessor' do
    assert Event::STATES == {"guest"=>0, "in_progress"=>1, "finished"=>2}
  end

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
    assert_equal search.count, 1
  end

  test "self.text_search location" do
    events = FactoryGirl.create_pair(:event)
    events.first.update_attributes(name: "Ballina")
    search = Event.text_search("Ballina")
    assert_equal search.count, 1
  end

  test "self.text_search about" do
    events = FactoryGirl.create_pair(:event)
    events.first.update_attributes(about: "The Magical Tour")
    search = Event.text_search("Magical")
    assert_equal search.count, 1
  end

  test "self.text_seach returns all if unfound" do
    events = FactoryGirl.create_pair(:event)
    assert_equal Event.text_search("").count, 2
  end

  test "auto_html html_escape" do
    event = FactoryGirl.build(:event, about: "<script>alert(0)</script>")
    assert_equal "<p>&lt;script&gt;alert(0)&lt;/script&gt;</p>\n", event.about_html
  end

  test "auto_html redcarpet" do
    event = FactoryGirl.build(:event, about: "This is **my** text.")
    assert_equal "<p>This is <strong>my</strong> text.</p>\n", event.about_html
  end

  test "auto_html responsive image" do
    event = FactoryGirl.build(:event, about: 'http://rors.org/images/rails.png')
    assert_equal "<p><img src='http://rors.org/images/rails.png' alt='' class='img-responsive'></p>\n", event.about_html
  end

  test "auto_html responsive youtube iframe" do
    event = FactoryGirl.build(:event, about: 'http://www.youtube.com/watch?v=BwNrmYRiX_o')
    assert_equal '<div class="flex-embed"><iframe width="400" height="250" src="//www.youtube.com/embed/BwNrmYRiX_o" frameborder="0" allowfullscreen></iframe></div>'+"\n", event.about_html
  end

  test "auto_html responsive vimeo iframe" do
    event = FactoryGirl.build(:event, about: 'http://www.vimeo.com/3300155')
    assert_equal '<div class="flex-embed"><iframe src="//player.vimeo.com/video/3300155?title=0&byline=0&portrait=0" width="400" height="250" frameborder="0"></iframe></div>'+"\n", event.about_html
  end

  test "auto_html soundcloud" do
    event = FactoryGirl.build(:event, about: 'https://soundcloud.com/creteboom/sets/them-bones-need-oxygen')
    assert_equal event.about_html, '<iframe width="400" height="250" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Fplaylists%2F745034&show_artwork=true&maxwidth=400&maxheight=250"></iframe>'+"\n"
  end

  test "auto_html resposive google map" do
    event = FactoryGirl.build(:event, about: 'http://maps.google.co.kr/maps?q=%ED%8C%8C%ED%8A%B8%EB%84%88%EC%8A%A4%ED%83%80%EC%9B%8C+1%EC%B0%A8&hl=ko&ie=UTF8&ll=37.472942,126.884762&spn=0.00774,0.010053&sll=37.473027,126.88451&sspn=0.003887,0.005026&vpsrc=6&gl=kr&hq=%ED%8C%8C%ED%8A%B8%EB%84%88%EC%8A%A4%ED%83%80%EC%9B%8C+1%EC%B0%A8&t=m&z=17&iwloc=A')
    assert_equal '<div class="flex-embed"><iframe width="400" height="250" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="//maps.google.co.kr/maps?f=q&amp;source=s_q&amp;q=%ED%8C%8C%ED%8A%B8%EB%84%88%EC%8A%A4%ED%83%80%EC%9B%8C+1%EC%B0%A8&amp;hl=ko&amp;ie=UTF8&amp;ll=37.472942,126.884762&amp;spn=0.00774,0.010053&amp;sll=37.473027,126.88451&amp;sspn=0.003887,0.005026&amp;vpsrc=6&amp;gl=kr&amp;hq=%ED%8C%8C%ED%8A%B8%EB%84%88%EC%8A%A4%ED%83%80%EC%9B%8C+1%EC%B0%A8&amp;t=m&amp;z=17&amp;iwloc=A&amp;output=embed"></iframe><br /><small><a href="//maps.google.co.kr/maps?f=q&amp;source=embed&amp;q=%ED%8C%8C%ED%8A%B8%EB%84%88%EC%8A%A4%ED%83%80%EC%9B%8C+1%EC%B0%A8&amp;hl=ko&amp;ie=UTF8&amp;ll=37.472942,126.884762&amp;spn=0.00774,0.010053&amp;sll=37.473027,126.88451&amp;sspn=0.003887,0.005026&amp;vpsrc=6&amp;gl=kr&amp;hq=%ED%8C%8C%ED%8A%B8%EB%84%88%EC%8A%A4%ED%83%80%EC%9B%8C+1%EC%B0%A8&amp;t=m&amp;z=17&amp;iwloc=A" style="color:#000;text-align:left">View Larger Map</a></small></div>'+"\n", event.about_html
  end

  test "auto_html link transform" do
    event = FactoryGirl.build(:event, about: "http://vukajlija.com")
    assert_equal '<p><a href="http://vukajlija.com" target="_blank" rel="nofollow">http://vukajlija.com</a></p>'+"\n", event.about_html
  end

end