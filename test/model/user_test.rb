require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # enums?
  should have_many(:event_users).dependent(:destroy)
  should have_many(:events).through(:event_users)
  # generate token
  # generate token

end