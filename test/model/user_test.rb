require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # enums?
  should have_many(:event_users).dependent(:destroy)
  should have_many(:events).through(:event_users)
  # generate token
  # generate token
  test "Factory should be valid" do
    user = FactoryGirl.create(:user)
    assert user.valid?
  end
end