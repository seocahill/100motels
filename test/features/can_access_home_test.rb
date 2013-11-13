require "test_helper"

class CanAccessHomeTest < Capybara::Rails::TestCase
  test "sanity" do
    visit root_path
    assert_content page, "100 Motels"
    refute_content page, "Fuck Everybody!"
  end
end
