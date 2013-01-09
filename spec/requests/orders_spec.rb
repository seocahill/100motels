require 'spec_helper'

describe "StripeButtonOrder" do

  let (:user) { FactoryGirl.create(:user) }
  let (:event) { FactoryGirl.create(:event) }

  it "show Success Message after purchase" do
    visit event_path(event)
    page.should have_content("Ticket Info")
    save_and_open_page
  end
end
