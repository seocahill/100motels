require 'minitest_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:events).through(:event_users)
  def valid_params
    { name: "John Doe" }
  end

  def test_valid
    user = User.new valid_params

    assert user.valid?, "Can't create with valid params: #{user.errors.messages}"
  end
end