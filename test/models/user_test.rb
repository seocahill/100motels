require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:events)
  should validate_presence_of(:name)
  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)
  should have_secure_password

  test "User Factory should be valid" do
    user = FactoryGirl.build(:user)
    assert user.valid?, "user factory not valid"
  end

  test "Guest User Factory should be valid" do
    user = FactoryGirl.build(:guest)
    assert user.valid?, "guest factory not valid"
  end

  test "enum_accessor" do
    assert User::STATES == {"unconfirmed"=>0, "normal"=>1, "suspended"=>2, "superadmin"=>3}
  end

  test "self.new_guest" do
    user = User.new_guest
    assert user.guest?
  end

  test "guest_user_event" do
    assert_difference "Event.count", 1 do
      FactoryGirl.create(:guest).guest_user_event
    end
  end

  test "move_to(user)" do
    event = FactoryGirl.create(:event)
    new_user = FactoryGirl.create(:user)
    event.user.move_to(new_user)
    assert new_user.events.include?(event), "Event weren't moved from Guest to new User"
  end

  test "confirm! generates token" do
    user = FactoryGirl.create(:user)
    user.confirm(user)
    refute_empty user.confirmation_token, "Token not generated"
  end

  test "confirm(user) sets confirmation_sent_at" do
    user = FactoryGirl.create(:user)
    user.confirm(user)
    refute_equal user.confirmation_sent_at, nil, "Confirmation time not set"
  end

  test "confirm(user) queues confirm email" do
    user = FactoryGirl.create(:user)
    assert_equal 0, Sidekiq::Extensions::DelayedMailer.jobs.size
    user.confirm(user)
    assert_equal 1, Sidekiq::Extensions::DelayedMailer.jobs.size
  end

  test "connect assigns stripe_connect credentitals" do
    user = FactoryGirl.create(:user)
    auth = OmniAuth.config.mock_auth[:stripe_connect]
    user.connect(auth)
    assert_equal user.stripe_uid, '12345', "Stripe uid not assigned"
    assert_equal user.api_key, 'secret_access', "Stripe customer api key not assigned"
  end

  test "send_password_reset generates token" do
    user = FactoryGirl.create(:user)
    user.send_password_reset
    refute_empty user.password_reset_token, "Token not generated"
  end

  test "send_password_reset sets confirmation_sent_at" do
    user = FactoryGirl.create(:user)
    user.send_password_reset
    refute_equal user.password_reset_sent_at, nil, "Password Reset time not set"
  end

  test "send_password_reset queues send_password_reset email" do
    user = FactoryGirl.create(:user)
    assert_equal 0, Sidekiq::Extensions::DelayedMailer.jobs.size
    user.send_password_reset
    assert_equal 1, Sidekiq::Extensions::DelayedMailer.jobs.size
  end


end