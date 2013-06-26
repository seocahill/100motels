require 'spec_helper'

feature "Manage Orders" do
  background do
    @order = create(:order)
  end

  scenario 'Customer cancels order after Event deferral' do
    visit cancel_order_url(@order.uuid)
    expect(page).to have_content "Your order has been cancelled"
  end
end